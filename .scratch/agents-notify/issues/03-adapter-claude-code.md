# 03: Adapter Claude Code

**What to build:** Prawdziwy agent Claude Code podpięty pod kręgosłup, E2E. Instancje claude uruchamiane przez `ai claude` (również te spawnowane z nvim — launcher nvim przestaje używać Alacritty na rzecz `ai claude`). Hooki w settings.json wołają wspólny `agent-hook`: `permission_prompt` i `agent_needs_input` → notify, `Stop` i `agent_completed` → done, `UserPromptSubmit` → working, `SessionEnd` → clear. Istniejące hooki notify-send (`permission_prompt`, `idle_prompt`) zostają podmienione; `idle_prompt` wylatuje jako duplikat Stop. Hooki synchroniczne (async może odpiąć PPID-łańcuch). Edycja `~/.claude/settings.json` in-place — plik pozostaje poza stow.

**Blocked by:** 01 (kręgosłup — agent-hook, ai, focus-window).

**Status:** resolved

- [x] `ai claude` działa; hook ma nienaruszony PPID-łańcuch do foot (zweryfikowane E2E) — *E2E: prawdziwe `ai claude -p` w standalone foot; pid w state == PID okna foot potwierdzony przez `hyprctl clients`*
- [ ] `permission_prompt` → stan notify + powiadomienie critical; klik focusuje okno — *hook skonfigurowany (matcher poprawny dla 2.1.281); w trybie `-p` nie strzela (brak interaktywnego UI permisji) — do odpalenia manualnie w sesji interaktywnej; ścieżka klik→focus zweryfikowana na żywo (dispatch `hl.dsp.focus` fokusem faktycznie zmienia activewindow)*
- [ ] `agent_needs_input` → notify — *matcher istnieje w 2.1.281 (strings binarki), ale strzela tylko dla jobów backgroundowych (roster fleetview/async agenty), NIE dla zwykłych synchronicznych subagentów Task — patrz Comments; trigger wymaga żywego background-agenta, manualne E2E*
- [x] `Stop`/`agent_completed` → done; `UserPromptSubmit` → working; `SessionEnd` → clear — *E2E: `claude -p` → working→done→clear (plik stanu zniknął po końcu sesji); realne powiadomienie done dostarczone do dunst (potwierdzone w `dunstctl history`)*
- [x] Stare hooki notify-send usunięte, `idle_prompt` nie wraca — *jq-edycja in-place `~/.claude/settings.json` (backup: `settings.json.bak-03`)*
- [x] Launcher claude w nvim otwiera `ai claude` (foot), nie Alacritty — *`external_terminal_cmd = "ai %s"`; setup nvim parsuje się czysto headless; realny spawn `<leader>ac` — manualnie*
- [x] Dwa agenty claude w tym samym projekcie są rozróżnialne i focus trafía we właściwy — *E2E: dwa okna foot w tym samym cwd → różne pid i address w `hyprctl clients`; `focus-window` focusem trafia we właściwe*

## Comments

- `~/.claude/settings.json`: Notification (permission_prompt|agent_needs_input → `agent-hook claude notify`, agent_completed → done), Stop → done, UserPromptSubmit → working (obok istniejącego `codegraph prompt-hook`), SessionEnd → clear. `idle_prompt` usunięty (duplikat Stop). Hooki synchroniczne (domyślne) — PPID-łańcuch do foot nienaruszony, potwierdzone E2E.
- **`agent_needs_input` a subagenty:** w 2.1.281 ten typ powiadomienia generuje roster jobów backgroundowych (fleetview — async agenty/teammates czekające na input: „X needs your input“). Zwykłe synchroniczne subagenty (Task) nie palą tego matchera — ich koniec łapie i tak `Stop`/`SubagentStop` sesji rodzica. Trigger manualny: background job w interaktywnej sesji.
- **`permission_prompt`:** w `-p` nie ma interaktywnego UI permisji → hook nie strzela; wymaga sesji interaktywnej (uwaga: launcher nvim używa `--dangerously-skip-permissions`, więc w instancjach z nvim ten matcher z definicji nie wystąpi — tam notify_REALnie palą się tylko agent_needs_input/done).
- **Bug znaleziony E2E (naprawiony):** Hyprland 0.55+ parsuje `hyprctl dispatch` jako jedno wyrażenie Lua — stara składnia `dispatch focuswindow address:…` z ticketa 01 pada z błędem parsera (stub w testach to maskował). `focus-window` przepisany na `hyprctl dispatch "hl.dsp.focus({ window = 'pid:<pid>' })"` — przy okazji krócej: selektor `pid:` rozwiązuje kompozytor w momencie dispatchu, cały rundtrip `hyprctl clients`→jq→address wyleciał. Zweryfikowane na żywo (dispatch ok + activewindow faktycznie się zmienia). Asercje stub-testu zaktualizowane, `bash agents/tests/test-agents.sh` → ALL PASS.
- E2E wykonane na żywym systemie (Hyprland 0.56 + foot + dunst + waybar): `ai claude -p` end-to-end (working→done→clear + powiadomienie w dunst), dwa równoległe agenty w tym samym projekcie (rozróżnialne po pid), prawdziwy focus przez nowy dispatch. Do manualnej weryfikacji pozostały tylko fizyczne interakcje: klik w popup dunst, trigger permission_prompt w sesji interaktywnej, spawn `<leader>ac` z nvim.
