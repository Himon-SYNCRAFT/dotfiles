# Spec: Powiadomienia + widget waybar dla wielu agentów AI (Hyprland)

Status: ready-for-agent

## Problem Statement

Odpalam równolegle kilka agentów AI (pi, Claude Code, opencode) w osobnych oknach na Hyprlandzie z różnymi zadaniami. Nie mam żadnego sygnału, że któryś skończył albo czeka na moją decyzję — muszę ręcznie zerkać w każde okno. Istniejące ad-hoc hooki (notify-send w Claude Code) nie są klikalne, nie prowadzą do okna agenta i nie agregują stanu wielu agentów.

## Solution

System zdarzeniowy: hooki/pluginy/extensions agentów piszą per-sesyjne pliki stanu do katalogu w tmpfs. Na ich podstawie: (1) dunst pokazuje powiadomienie z akcją — klik focusuje okno agenta; (2) widget waybara liczy agentów czekających na odpowiedź — klik otwiera dmenu z listą, wybór focusuje właściwe okno. Korelacja okna po PID-ie procesu terminala, nie po tytułach (Claude Code nadpisuje tytuł, footclient dzieli PID serwera).

## User Stories

1. Jako developer odpalający kilka agentów równolegle, chcę powiadomienie desktopowe, gdy agent skończy zadanie, żebym nie musiał pollować okien.
2. Jako developer, chcę powiadomienie, gdy agent pyta o pozwolenie lub moją odpowiedź, żebym nie blokował pipeline'u.
3. Jako użytkownik, chcę kliknąć powiadomienie i trafić fokusem do okna agenta, który je wysłał, żebym od razu widział kontekst.
4. Jako użytkownik, chcę widget na pasku pokazujący liczbę agentów czekających na moją reakcję, żebym miał stały, zerowy-kosztowy przegląd sytuacji.
5. Jako użytkownik, chcę kliknąć widget i zobaczyć listę czekających agentów (dmenu), żebym wybrał dokąd skoczyć.
6. Jako użytkownik, wybór pozycji z listy ma focusować okno tego agenta (łącznie z przełączeniem workspace'u), żebym lądował dokładnie tam gdzie trzeba.
7. Jako użytkownik, wpis "czeka" ma wisieć dopóki nie zareaguję (następny prompt), bo done też wymaga mojej uwagi.
8. Jako użytkownik, pracujący agent NIE ma palić powiadomień ani licznika, inaczej 5 agentów generuje szum.
9. Jako użytkownik, wpis znika gdy sesja się kończy lub proces ginie (lazy pruning), żebym nie miał widm w liście.
10. Jako użytkownik, kolejne powiadomienie tej samej sesji zastępuje poprzednie, nie stackuje — max jedno popup-okno na sesję.
11. Jako użytkownik, chcę łatwo przełączyć czy widget przy zerze znika czy pokazuje "0", bo nie wiem czy pusty moduł nie będzie mi psuł layoutu paska.
12. Jako użytkownik, widget ma się aktualizować natychmiast (sygnał), nie cyklicznie (poll), żebym widział stan w chwili zdarzenia.
13. Jako launcher, chcę wrapper `ai <agent>`, który odpala agenta w dedykowanej standalone instancji foot, żeby konwencja PID-ów była zachowana zawsze i wszędzie (także z nvim).
14. Jako użytkownik nvim, instancje claude uruchamiane z nvim otwierają się we foot (nie Alacritty), żeby podlegały temu samemu systemowi.
15. Jako użytkownik pi, użycie wbudowanego narzędzia `ask` ma palić notify, bo to jedyny moment gdy pi prosi o input (tryb bez pozwolenień).
16. Jako użytkownik Claude Code, `permission_prompt` i `agent_needs_input` palą notify, `Stop`/`agent_completed` palą done, `UserPromptSubmit` wraca do working.
17. Jako użytkownik opencode, `permission.updated` pali notify, `session.idle` done, `session.status` busy working, `session.deleted` clear.
18. Jako użytkownik dwóch agentów w tym samym projekcie, oba mają być rozróżnialne (PID okna, nie projekt), żeby focus trafiał w ten właściwy.
19. Jako użytkownik, powiadomienie "prosi o input" ma być critical (wisi aż kliknę), "skończył" normal (sam znika, zostaje widget).
20. Jako właściciel dotfiles, nowe skrypty i pluginy mają być w pakiecie stow, a żywe pliki konfiguracyjne (claude settings, pi extensions) edytowane in-place poza repo, żeby repo nie brudziło się stanem.
21. Jako operator, system ma działać bez daemona (stan = pliki w tmpfs, każdy writer dotyka tylko swojego pliku), żeby awarie nie korumpowały stanu i nie było procesu do restartowania.
22. Jako operator, stan ma przeżyć restart waybara (katalog w XDG_RUNTIME_DIR), ale nie restart systemu (auto-czyszczenie), żeby nie było starych wpisów po reboot.

## Implementation Decisions

- Pięć skryptów w `~/.local/bin`: `ai` (launcher), `agent-hook` (wspólny zapis stanu + notyfikacja + sygnał do waybara), `agents-widget` (render licznika), `agents-pick` (lista dmenu), `focus-window` (PID → address → focus). Plus helper notyfikacji z wiszącym round-tripem dunstify.
- Schema pliku stanu: `{agent, project, cwd, event, pid, ts, message}` klucz = session_id; słownik zdarzeń: `working | notify | done`; `clear` = usunięcie pliku.
- Korelacja okna: hook robi PPID-walk po `/proc` od siebie do PID procesu terminala i zapisuje go w stanie; focus rozwiązuje PID → window address przez `hyprctl clients` **w momencie kliku** (adresy są ulotne, nie trzymamy ich).
- Twarda konwencja: agenty uruchamiane wyłącznie jako standalone instancje foot (`ai` wrapper) — okna footclient mają PID serwera i są nierozróżnialne; tytuły okien NIE są używane do korelacji (Claude Code nadpisuje tytuł jednakowo dla wszystkich instancji).
- Etykiety dla człowieka (dmenu/tooltip) pochodzą ze state file (agent · projekt · status), nie z tytułów okien.
- Waybar: moduł custom, `return-type: json`, `interval: once` + aktualizacja sygnałem SIGRTMIN+8; licznik = notify + done. Toggle pusto/zero jedną zmienną na górze skryptu widgetu.
- Notyfikacje: dunstify z akcją default; helper wisi do kliknięcia/wygaśnięcia; replace per sesja przez stack-tag; `mouse_left_click = do_action` w dunstrc (dzisiaj default zamyka powiadomienie).
- Sygnał do waybara: `pkill -RTMIN+8 waybar` z agent-hook; numer zweryfikowany jako wolny w obecnym configu.
- Adaptery per harness: claude — hooki w settings.json (istniejące hooki notify-send podmienione, `idle_prompt` usunięty jako duplikat Stop), opencode — plugin ładowany z katalogu pluginów, pi — extension w katalogu extensions. Wszystkie trzy wołają ten sam `agent-hook`.
- Opencode: payloady eventów zweryfikowane z typów SDK zainstalowanej wersji (`permission.updated`, `session.idle`, `session.status{idle,busy,retry}`, `properties.sessionID`).
- Rozmieszczenie: nowy pakiet stow `agents/` (skrypty, plugin opencode, testy); edycje in-place w istniejących pakietach waybar i dunst; `~/.claude/settings.json` i `~/.pi/agent/extensions/` poza stow.
- Zwykłe terminale użytkownika (footclient) nietknięte.

## Testing Decisions

- Dobry test = wyłącznie zachowanie zewnętrzne: zawartość katalogu stanu po wywołaniu `agent-hook`, jednolinijkowy JSON widgetu (kontrakt waybara), linie listy dmenu, wywołania `hyprctl` przechwycone przez stub w PATH. Zero testów wewnętrznych funkcji skryptów.
- Jeden automatyczny seam: skrypty nad fixture-owym katalogiem stanu (tmpdir jako XDG_RUNTIME_DIR) + stub `hyprctl`. Jeden plik testowy assert-based w bash, uruchamialny ręcznie; brak frameworka (repo nie ma żadnych testów — tworzymy minimalny precedens).
- Seam manualny E2E: prawdziwy agent w prawdziwym foot, wywołane zdarzenia, ręczna weryfikacja notification→klik→focus i widget→dmenu→focus. Ten seam weryfikuje też ryzyka PPID per harness (patrz Further Notes).
- Adaptery hooków (claude/opencode/pi) nie mają własnych automatycznych testów — to cienkie wrappery na `agent-hook`, pokryte seamem E2E.

## Out of Scope

- Listener socket2 Hyprlanda (auto-clear wpisu przy focusie okna) — wymaga socat + stały proces; wpis znika i tak przy następnym prompcie.
- Auto-clear po TTL.
- Window rules / kolory obramowań oczekujących okien (Hyprland 0.56 = config Lua; osobny temat).
- Native menu waybara (statyczny XML — nie da się dynamicznie), wofi/rofi/bemenu.
- Zarządzanie `~/.claude` i `~/.pi` w stow.
- Kolejni agenci (codex, gemini, omp) — architektura jest otwarta na dodanie adaptera.
- tmux/panes (poza ekosystemem).

## Further Notes

- Ryzyka do potwierdzenia przy implementacji seamem E2E: (1) czy hook claude / plugin opencode / extension pi mają nienaruszony łańcuch PPID do procesu foot (hooki muszą być synchroniczne, nie async — async może odpiąć od rodzica); (2) czy `agent_needs_input` faktycznie strzela w zainstalowanej wersji claude (2.1.281) przy subagentach.
- pi nie ma trybu pozwoleń w tej wersji (research pierwotny mylnie zakładał `tools.approvalMode`) — jedyny sygnał "prosi o input" to narzędzie `ask`.
- Claude Code nie pozwala кастomizować tytułu okna (otwarty feature request upstream anthropics/claude-code#34929) — dlatego korelacja po PID jest jedyną wiarygodną drogą.
- Wszystkie okna footclient zgłaszają PID serwera foot — dlatego konwencja standalone foot jest twardym wymogiem, nie preferencją.
- Wstępny research: `NOTES/hyprland-multi-agent-workflow.md` (uwaga: część założeń z notatki — konwencja tytułów, `tools.approvalMode` pi — została w grillingu unieważniona przez fakty z systemu; ten spec jest źródłem prawdy).
