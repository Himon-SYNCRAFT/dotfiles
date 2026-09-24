# 02: Widget waybar + picker dmenu

**What to build:** Widoczny przegląd oczekujących agentów na pasku. Widget `custom/agents` w waybarze (`return-type: json`, `interval: once`, aktualizacja wyłącznie sygnałem SIGRTMIN+8) liczy sesje w stanie `notify` + `done` i renderuje licznik; tooltip listuje sesje (etykiety `agent · projekt — status` ze state file). Jednolinijkowa zmienna na górze skryptu widgetu przełącza zachowanie przy zerze: ukryty moduł vs stale widoczne "0" (layout paska ma nie drgać w trybie ukrytym). Klik w widget otwiera dmenu z listą czekających sesji (linia = `agent · projekt (status)`); wybór pozycji wywołuje `focus-window <pid>` i focusuje okno agenta (łącznie z przełączeniem workspace'u). Leniwy pruning martwych PID-ów przy renderze. Edycja configu waybara in-place w istniejącym pakiecie.

**Blocked by:** 01 (kręgosłup — agent-hook, focus-window, sygnał, state dir).

**Status:** resolved

- [x] Widget pokazuje liczbę sesji notify+done; przy `working` sesje nie są liczone — *stub-test: text=2 przy fixture notify+done+working+dead*; żywy waybar — E2E
- [x] Aktualizacja natychmiastowa po sygnale, bez pollingu — *config: `interval: "once"` + `signal: 8` (SIGRTMIN+8, weryfikowane w man waybar-custom 0.15); `pkill -RTMIN+8` z agent-hook już pokryte testem*; odświeżenie po restarcie waybara — E2E
- [x] Toggle pusto/zero działa jedną zmienną na górze skryptu, bez edycji configu waybara — *`SHOW_ZERO` w `agents-widget` (env-overridable); hidden = pusty `text` + `hide-empty-text: true` → moduł zwija się w całości, layout nie drga; stub-test obu trybów*
- [x] Klik → dmenu z etykietami ze state file; wybór focusuje właściwe okno — *stub-test: `agents-pick` → `focus-window <pid>` → `hyprctl dispatch focuswindow address:…`; duplikaty etykiet (ten sam agent+projekt) dostają sufiks `[#pid]` (story 18)*; prawdziwe dmenu+klik — E2E
- [x] Tooltip listuje sesje z etykietami `agent · projekt — status` — *status mapowany: notify→czeka, done→gotowe; stub-test*
- [x] Wpisy z martwym PID-em nie renderują się (lazy pruning) — *przy renderze plik stanu z martwym PID jest usuwany (`rm`), pid 0 (nie znaleziono terminala) zostaje; stub-test*
- [x] Test assert-based: fixture state dir → JSON widgetu (kontrakt waybara), linie dmenu, wywołanie focus przez stub `hyprctl` — `bash agents/tests/test-agents.sh` → ALL PASS

## Comments

- `agents-widget` (bez arg → JSON waybara; `agents-widget lines` → wiersze `pid<TAB>etykieta` dla pickera — jedno źródło logiki prune+filter, bez szóstego skryptu).
- Waybar: moduł `custom/agents` w istniejącym pakiecie (config + style.css); `hide-empty-text` wymaga waybara ≥ 0.10.3 (mamy 0.15.0).
- Etykiety: `agent · projekt (status)` w dmenu, `agent · projekt — status` w tooltipie; status słownie po polsku (czeka/gotowe), dane ze state file.
- Pozostałe do E2E (żywy waybar/dmenu/Hyprland): render po sygnale, zwijanie modułu przy zerze, prawdziwy klik w dmenu → focus + przełączenie workspace.
