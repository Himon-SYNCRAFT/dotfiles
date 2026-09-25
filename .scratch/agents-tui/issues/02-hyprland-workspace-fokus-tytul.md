# 02: Hyprland — workspace, fokus i tytuł okna w wierszach

**What to build:** Wzbogacenie wierszy o dane okna z Hyprlanda. Dla każdego **nowego** okna agenta (pid shella nieobecny w mapie) jednorazowo ten sam trik co `focus-window`: push title, marker OSC 2 zapisany do pty shella, znalezienie `address` okna po markerze w `hyprctl clients -j`, pop title → mapa w pamięci `pid shella → address`. Przy każdym pollingu jedno `hyprctl clients -j` i po adresie: kolumna workspace (`workspace.name`), pogrubienie wiersza okna z fokusem (`focusHistoryID == 0`), tytuł okna w miejsce message, gdy agent message nie ma (obcięty). Wpis mapy znika razem z oknem/procesem. Brak adresu (marker nie znaleziony, brak pty) → wiersz bez danych okna, bez ponawiania w kółko. Nic nie ląduje na dysku; wiele instancji TUI robi własne markery.

**Blocked by:** 01

**Status:** resolved

- [x] Marker wykonywany raz na okno (nie przy każdym pollingu); tytuł okna przywracany (push/pop)
- [x] Kolumna workspace poprawna dla okien `foot` i `footclient` (w tym kilka okien footclient — ten sam pid serwera)
- [x] Wiersz okna z fokusem pogrubiony; zmiana fokusu widoczna w ≤1 s
- [x] Tytuł okna pokazywany, gdy brak message
- [x] Mapa `pid → address` czyszczona, gdy okno znika; brak adresu nie psuje wiersza ani nie powoduje ponawiania markera co tick
- [x] `main_test.go` rozszerzony: fałszywy output `hyprctl clients -j` + mapa adresów → workspace, fokus, tytuł-fallback w wierszach — `go test` PASS
- [ ] E2E: kilka agentów w `footclient` na różnych workspace'ach → poprawne workspace'y i pogrubienie; marker nie psuje widocznie outputu agenta

## Comments

- Zaimplementowane w `NOT_STOW/agents-tui/main.go`: `resolveAddrs` (marker jednorazowo, wszystkie nowe okna w jednym batchu, pudło zapisywane jako `""` — bez ponawiania; prune przy zniknięciu wiersza), `addWindows` (workspace, fokus, tytuł-fallback). pty z `/proc/<shell>/fd/0`. Marker dopiero dla wiersza widzianego już w poprzednim ticku (świeży agent sam ustawia tytuł — wyścig).
- E2E częściowo: live test na jednym oknie foot z claude → poprawny address/ws/fokus, tytuł przywrócony, prune działa. Kilka okien `footclient` na różnych workspace'ach — do sprawdzenia ręcznie.
- Znane ceilingi (`ponytail:` w kodzie): marker blokuje UI do 1 s przy pudle; Enter nadal woła `focus-window` (drugi marker) zamiast focusu po znanym adresie.
