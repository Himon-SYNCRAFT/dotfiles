# Spec: TUI z listą działających agentów AI (Hyprland)

Status: ready-for-agent

## Problem Statement

System z `agents-notify` (hooki → pliki stanu → dunst/waybar/dmenu) pokazuje tylko agentów, którzy **czekają** na reakcję (notify/done), i wymaga odpalania agentów przez wrapper `ai`. Nie mam jednego widoku wszystkich działających agentów (claude, opencode, pi) z ich bieżącymi statusami, z którego mogę skoczyć do okna dowolnego z nich — również tych odpalonych zwykłym `footclient`, bez wrappera.

## Solution

`agents-tui` — TUI w Go (bubbletea), stale otwarty monitor. Polling co 1 s: lista działających agentów budowana z **procesów** (`/proc`), status dociągany z istniejących plików stanu hooków, informacje o oknie z `hyprctl clients`. Enter na wierszu → `focus-window` na okno agenta; TUI zostaje otwarte. TUI niczego nie zapisuje na dysk ani nie kasuje — jest czystym czytelnikiem.

## User Stories

1. Jako developer z kilkoma agentami, chcę jedną listę wszystkich działających agentów (claude, opencode, pi) z bieżącymi statusami, żeby widzieć całość bez zaglądania w okna.
2. Jako użytkownik, chcę wybrać wiersz klawiaturą (`j`/`k`/strzałki, `Enter`) i trafić fokusem do okna tego agenta (łącznie z przełączeniem workspace'u).
3. Jako użytkownik, TUI ma zostać otwarte po wyborze — to monitor, nie picker.
4. Jako użytkownik, TUI ma działać z każdym agentem w oknie `foot` i `footclient`, bez wrappera `ai` i bez specjalnego sposobu uruchamiania agentów.
5. Jako użytkownik, świeżo odpalony agent (przed pierwszym promptem) ma być widoczny od razu — jako „bezczynny”.
6. Jako użytkownik, zamknięty/zabity agent ma zniknąć z listy sam (nie ma procesu → nie ma wiersza), bez żadnego sprzątania.
7. Jako użytkownik, agenci bez okna foot w łańcuchu przodków (headless `claude -p`, inne terminale) mają być ukryci — z listy nie da się do nich skoczyć.
8. Jako użytkownik, jedno okno = jeden wiersz, nawet jeśli w oknie jest kilka procesów agentów (np. claude odpala `opencode run` w Bash) — pokazuję agenta najbliższego `foot`.
9. Jako użytkownik, wiersze wymagające uwagi mają być na górze: czeka → gotowe → pracuje → bezczynny; w grupie od najstarszego.
10. Jako użytkownik, chcę widzieć: agent · projekt · status · wiek · workspace · message (obcięte do szerokości); gdy brak message — tytuł okna.
11. Jako użytkownik, wiersz okna, które ma aktualnie fokus, jest pogrubiony.
12. Jako użytkownik dwóch agentów w tym samym projekcie, duplikaty etykiet mają sufiks z pid (jak w `agents-pick`).
13. Jako użytkownik, mogę uruchomić TUI dowolną liczbę razy (skrót, CLI) — instancje są niezależne; skrót ustawiam sam.
14. Jako właściciel dotfiles, budowa to jedna komenda `go build`, binarka nie ląduje w repo, `stowall.sh` bez zmian.

## Implementation Decisions

- **Źródła danych i ich odpowiedzialności** (bez synchronizacji — każde źródło odpowiada za co innego):
  1. **Procesy** (`/proc`) — o istnieniu. Proces agenta → PPID-walk do bezpośredniego dziecka `foot` (shell okna) — ten sam algorytm co w `agent-hook`; działa dla `foot` i `footclient` (każde okno footclient ma własny shell). Wynik: `pid shella okna`.
  2. **Pliki stanu** (`$XDG_RUNTIME_DIR/agents/*.json`, schema `{agent, project, cwd, event, pid, ts, message}`) — tylko o statusie. Łączenie po `pid` (= pid shella okna). Brak pliku → „bezczynny”. Plik bez odpowiadającego procesu → ignorowany (nie kasowany).
  3. **Hyprland** — o oknie. Dla każdego **nowego** okna jednorazowo ten sam trik co `focus-window` (push title, marker OSC 2 do pty, znalezienie `address` w `hyprctl clients -j`, pop title) → mapa w pamięci `pid shella → address`. Przy każdym pollingu `hyprctl clients -j` po adresie: `workspace.name`, `focusHistoryID == 0` (fokus), `title`. Wpis mapy znika, gdy okno/proces znika.
- Rozpoznanie agenta po procesie: claude / opencode / pi. Dokładne kryterium (comm vs argv — pi i opencode mogą działać jako `node`/`bun`) do zweryfikowania przy implementacji na żywych procesach.
- Mapowanie statusów: `notify` → czeka, `done` → gotowe, `working` → pracuje, brak pliku → bezczynny. Wiek: od `ts` pliku stanu; bez pliku — od startu procesu agenta.
- Projekt bez pliku stanu: `basename` cwd procesu agenta (`/proc/<pid>/cwd`).
- Focus: `Enter` → exec `focus-window <pid shella>` (istniejący skrypt, bez przepisywania do Go).
- Polling: `tea.Tick` co 1 s, sam stdlib do `/proc` i JSON; `hyprctl` wołany przez `os/exec` (`HYPRLAND_INSTANCE_SIGNATURE` dziedziczone z środowiska).
- Zależności: bubbletea + lipgloss. Nic więcej (bez bubbles/table, bez fsnotify).
- Klawiatura: `j`/`k`/strzałki, `Enter`, `q`/`ctrl+c`. Bez myszy.
- Wiele instancji: dozwolone, bez wykrywania duplikatów; każda instancja robi własne jednorazowe markery.
- **Rozmieszczenie**: źródło w `NOT_STOW/agents-tui/` (własny `go.mod`) — `stowall.sh` bez zmian, a pakiet stow `agents/` stowowałby katalog źródeł do `$HOME`. Build: `go build -C NOT_STOW/agents-tui -o ~/.local/bin/agents-tui .` (komenda w komentarzu na górze `main.go`). Binarka poza repo.
- Istniejący system (`agent-hook`, adaptery, `agents-widget`, `agents-pick`, `ai`, skrót `SUPER+A`) — bez zmian.

## Testing Decisions

- Jeden `main_test.go`: fixture'owy katalog stanu + fałszywa lista procesów (agent → pid shella, cwd, start) + fałszywy output `hyprctl clients -j` → oczekiwane, posortowane wiersze. Pokrywa: łączenie po pid, „bezczynny” przy braku pliku, ignorowanie pliku bez procesu, jeden wiersz na okno, ukrycie agentów bez foot, sortowanie, sufiks pid przy duplikatach.
- Żeby test był możliwy, budowanie wierszy to czysta funkcja nad danymi (procesy, pliki stanu, klienci Hyprlanda); skan `/proc`, `hyprctl` i marker to cienkie I/O dookoła.
- Bez testów UI bubbletea.
- E2E manualnie: claude/opencode/pi w `foot` i w `footclient` (w tym dwa w tym samym projekcie) → poprawne statusy, workspace, pogrubienie fokusu; `Enter` → focus właściwego okna; zamknięcie agenta → wiersz znika w ≤1 s.

## Out of Scope

- Mysz, dismiss wpisów, kill sesji, filtrowanie.
- Zmiany w adapterach hooków (zdarzenie `idle` niepotrzebne — świeży agent widoczny z procesu).
- Zmiany w `stowall.sh`, usunięcie `agents-pick`/dmenu, zmiana `SUPER+A` / kliknięcia widgetu.
- Scratchpad / special workspace / reguły okien dla TUI; wykrywanie już otwartej instancji.
- Monitor, historia fokusu jako kolumny.
- Natywny rejestr Claude (`~/.claude/sessions/<pid>.json`) — hooki już dają status.
- Agenci w terminalach innych niż foot, tmux/panes.

## Further Notes

- Hyprland rozróżnia okna footclient (`address`, `stableId`), ale nie wie, jaki proces w nich działa (`pid` = serwer foot, brak info o pty) — stąd jednorazowy marker; tytuł okna nie nadaje się do korelacji (claude go nadpisuje).
- Ryzyko markera: jednorazowy zapis do pty może się wymieszać z outputem TUI agenta (ten sam znany ceiling co w `focus-window`).
- Rozpoznane gotowce (agent-ps, agentop, agent-of-empires, agent-deck, herdr) odrzucone: brak statusu „czeka na input” dla wszystkich trzech agentów, brak focusu okna Hyprlanda, część to multipleksery sprzeczne z modelem „okno = agent”.
- Kontekst: `.scratch/agents-notify/spec.md` (system hooków i plików stanu, na którym TUI czyta).
