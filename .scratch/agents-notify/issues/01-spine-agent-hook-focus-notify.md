# 01: Kręgosłup — launcher `ai`, `agent-hook`, `focus-window`, klikalne powiadomienie

**What to build:** Pełna ścieżka zdarzenia na sztucznym agencie, end-to-end. Odpalenie `ai bash` otwiera standalone instancję foot (unikalny PID okna). Wywołane w niej ręcznie `agent-hook <agent> <event>` (z JSON-em sesji na stdin) robi trzy rzeczy: zapisuje plik stanu per sesja do katalogu w XDG_RUNTIME_DIR (schema `{agent, project, cwd, event, pid, ts, message}`, słownik `working | notify | done`, `clear` = usuwa plik, pid z PPID-walku po /proc do procesu terminala), wysyła powiadomienie dunst z akcją default (helper wisi do kliknięcia/wygaśnięcia, replace per sesja przez stack-tag, notify=critical, done=normal) i sygnalizuje waybar (SIGRTMIN+8). Klik w powiadomienie odpala `focus-window <pid>`, który w momencie kliku rozwiązuje PID → window address przez `hyprctl clients` i focusuje okno. Zawiera też pakiet stow `agents/` (skrypty w `~/.local/bin`) + wpis w `stowall.sh` oraz edycję `dunstrc` (`mouse_left_click = do_action` — default zamyka powiadomienie bez akcji).

**Blocked by:** None (can start immediately).

**Status:** resolved

- [ ] `ai <cmd>` otwiera standalone foot; PID okna jest unikalny (nie PID serwera footclient) — *kod gotowy (`agents/.local/bin/ai`: `exec foot` bez serwera); weryfikacja wymaga sesji Hyprland (E2E)*
- [x] `agent-hook` zapisuje/aktualizuje/usuwa plik stanu zgodnie ze schema; równoległe writery nie kontendują (każdy dotyka tylko swojego pliku)
- [x] PPID-walk z procesu wołającego dociera do PID terminala; PID zapisany w stanie — *test: kopia basha nazwana `foot` jako rodzic, assert pid w stanie == PID tego "terminala"; realny łańcuch przez harnessy — E2E*
- [ ] Powiadomienie dunst: klik lewym przyciskiem focusuje właściwe okno (window address rozwiązany w momencie kliku) — *kod gotowy (stub-test weryfikuje pid→address→dispatch); prawdziwy klik w dunst — E2E*
- [ ] Kolejne zdarzenie tej samej sesji zastępuje powiadomienie (stack-tag), nie stackuje — *`--stack-tag <sid>` przekazywany (assert w teście); zachowanie replace w prawdziwym dunst — E2E*
- [x] `dunstrc` ma `mouse_left_click = do_action`
- [x] Pakiet stow `agents/` istnieje, `stowall.sh` go stowuje, skrypty lądują w `~/.local/bin` — *dry-run stow czysty; testy wykluczone `--ignore=tests`*
- [x] Test assert-based przechodzi: fixture state dir (tmpdir jako XDG_RUNTIME_DIR) + stub `hyprctl` w PATH; asercje na pliki stanu, wywołania focus-window przez stub; zero testów wewnętrznych funkcji — `bash agents/tests/test-agents.sh` → ALL PASS

## Comments

- Zaimplementowane w pakiecie `agents/`: `.local/bin/{ai,agent-hook,agent-notify,focus-window}` + `tests/test-agents.sh` (stub `dunstify`/`hyprctl`/`pkill`, tmpdir jako XDG_RUNTIME_DIR). Stub dunstify symuluje klik przez `STUB_DUNST_ACTION=default` → asercja na `hyprctl dispatch focuswindow address:…` z fixture JSON klientów.
- `agent-hook`: PPID-walk po `/proc` (comm == `foot`, fallback topmost ancestor), atomowy zapis (tmp+mv), sygnał `pkill -RTMIN+8 -x waybar`. `agent-notify` odpalany w tle (helper wisi do kliknięcia/wygaśnięcia — hook nie może blokować).
- `dunstrc`: `mouse_left_click = do_action` (było `close_current`).
- Pozostałe niewytickowane pola wymagają żywej sesji Hyprland+dunst — manualny seam E2E ze specu (Testing Decisions). Ryzyka E2E: realny łańcuch PPID per harness (hooki claude muszą być synchroniczne) i replace po stack-tag w prawdziwym dunst.

## Post-resolution note (from ticket 03)

- E2E ticketa 03 wyszło na jaw, że na Hyprlandzie 0.55+ `hyprctl dispatch focuswindow address:…` pada (dispatch jest teraz jedno-wyrażeniowym Lua; stub w testach maskował błąd). `focus-window` przepisany na `hyprctl dispatch "hl.dsp.focus({ window = 'pid:<pid>' })"` — selektor `pid:` rozwiązuje kompozytor w momencie dispatchu, rundtrip clients→jq→address usunięty. Zweryfikowane na żywym systemie. Niewytickowane wyżej pola E2E (klik w dunst, replace po stack-tag) nadal czekają na manualną weryfikację.
