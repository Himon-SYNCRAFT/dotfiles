# 01: Tracer — lista agentów z procesów + status z plików stanu + Enter → focus

**What to build:** Działające `agents-tui` end-to-end bez Hyprlanda w liście. Moduł Go w `NOT_STOW/agents-tui/` (własny `go.mod`, zależności: bubbletea + lipgloss; komenda buildu `go build -o ~/.local/bin/agents-tui ./NOT_STOW/agents-tui` w komentarzu na górze `main.go`). Co 1 s (`tea.Tick`): skan `/proc` → procesy claude / opencode / pi → PPID-walk do bezpośredniego dziecka `foot` (pid shella okna, ten sam algorytm co `agent-hook`; działa dla `foot` i `footclient`). Agenci bez `foot` w łańcuchu — ukryci. Jedno okno = jeden wiersz (agent najbliższy `foot`). Status z `$XDG_RUNTIME_DIR/agents/*.json` łączony po `pid` (notify → czeka, done → gotowe, working → pracuje, brak pliku → bezczynny); plik bez procesu ignorowany, TUI niczego nie zapisuje ani nie kasuje. Wiersz: `agent · projekt · status · wiek · message` (projekt/wiek z pliku stanu, fallback: basename `/proc/<pid>/cwd` / start procesu; message obcięte do szerokości), sufiks pid przy zdublowanych etykietach. Sortowanie: czeka → gotowe → pracuje → bezczynny, w grupie od najstarszego. Klawiatura: `j`/`k`/strzałki, `Enter` → `focus-window <pid shella>` (TUI zostaje otwarte), `q`/`ctrl+c`. Budowanie wierszy jako czysta funkcja nad danymi (procesy, pliki stanu) — I/O cienko dookoła.

Najpierw zweryfikować na żywych procesach, po czym rozpoznać pi i opencode (comm vs argv — mogą działać jako `node`/`bun`) i zapisać kryterium w Comments.

**Blocked by:** None (can start immediately).

**Status:** ready-for-human

- [x] Kryterium rozpoznania claude / opencode / pi zweryfikowane na żywych procesach i opisane w Comments
- [x] `go build` z komendy w `main.go` produkuje `~/.local/bin/agents-tui`; binarka nie trafia do repo; `stowall.sh` bez zmian
- [x] Lista: jeden wiersz na okno, agenci bez foot ukryci, status z pliku stanu po pid shella, brak pliku → bezczynny, plik bez procesu ignorowany
- [x] Sortowanie po statusie, w grupie od najstarszego; sufiks pid przy duplikatach etykiet
- [x] Polling 1 s: nowy agent pojawia się, zamknięty znika (≤1 s), bez zapisu/kasowania czegokolwiek na dysku
- [x] `Enter` wywołuje `focus-window <pid shella>`, TUI zostaje otwarte; `j`/`k`/strzałki/`q` działają
- [x] `main_test.go`: fixture katalog stanu + fałszywa lista procesów → oczekiwane posortowane wiersze (łączenie po pid, bezczynny, ignorowany plik bez procesu, jeden wiersz na okno, ukrycie bez foot, sortowanie, sufiks pid) — `go test` PASS
- [ ] E2E: claude, opencode, pi w `foot` i w `footclient` (w tym dwa w jednym projekcie) → poprawne statusy; `Enter` focusuje właściwe okno

## Comments

### 2026-09-25 — implementacja (agent)

**Kryterium rozpoznania (zweryfikowane na żywych procesach):** `/proc/<pid>/comm` ∈ {`claude`, `opencode`, `pi`}. Wszystkie trzy są natywnymi binarkami ELF nazwanymi jak komenda (claude → `~/.local/share/claude/versions/*`, opencode → `~/.opencode/bin/opencode`, pi → mise `installs/pi/*/pi`), więc `comm` wystarcza — argv niepotrzebne. Nie działają jako `node`/`bun`. Instalacja przez npm (`node …`) nie zostałaby rozpoznana — dopisać do `agentComms` gdyby kiedyś tak było.

**Build:** komenda ze specu (`go build -o … ./NOT_STOW/agents-tui`) z roota repo nie działa — moduł jest zagnieżdżony, a w roocie nie ma `go.mod`. Użyte: `go build -C NOT_STOW/agents-tui -o ~/.local/bin/agents-tui .` (komentarz w `main.go`; `spec.md` zaktualizowany).

**Decyzje:** plik stanu łączony po `pid` **i** `agent` == `comm` (adaptery wołają `agent-hook claude|opencode|pi`), najnowszy `ts` wygrywa; plik z `ts` starszym niż start procesu agenta = poprzednia sesja w tym oknie bez `clear` → ignorowany (poprawka po code review: inaczej zagnieżdżony `opencode run` albo zabity agent podmieniałby status). Nieznany `event` → plik ignorowany. Agent, którego przodek (pod `foot`) też jest agentem → pomijany (wiersz dostaje agent najbliższy `foot`). Enter → `focus-window` przez `cmd.Start()` + reap w goroutine, TUI nie jest wstrzymywane.

**Weryfikacja:** `go test` PASS. Na żywo przez pty: ta sesja claude → `pracuje`; fałszywy `foot` (kopia bash, comm=foot) z opencode + pi + dwa opencode w jednym projekcie (sufiks `[#pid]`) + `claude -p` (bezczynny → pracuje po hooku); po zamknięciu wiersze znikają. Brak zapisów w katalogu stanu przez TUI.

**Do zrobienia przez człowieka (ostatni checkbox):** E2E w prawdziwych oknach `foot`/`footclient` + `Enter` → fokus właściwego okna (nie otwierałem okien na Twoim pulpicie).
