# 03: Widok kolumnowy — folder, gałąź git, message, status, agent

**What to build:** Zamiana wiersza `agent · projekt · status · wiek · ws · message` na wyrównane kolumny `FOLDER | GAŁĄŹ | MESSAGE | STATUS | AGENT` z przygaszonym (faint) nagłówkiem, bez ramek.

- **Folder**: jak dotąd (`project` z pliku stanu, inaczej `basename` cwd). Szerokość = najdłuższa wartość, max 20, dalej `…`.
- **Gałąź**: z `.git/HEAD` w cwd procesu agenta, z wędrówką w górę drzewa katalogów (worktree: `.git` jest plikiem `gitdir: …`). Bez wołania `git`. Poza repo `—`, detached HEAD → 7 znaków sha. Szerokość = najdłuższa, max 24, dalej `…`.
- **Message**: message ze stanu, inaczej tytuł okna (jak dotąd). Zajmuje resztę szerokości, obcinana z `…`; w wąskim oknie kurczy się pierwsza, do zera.
- **Status**: stała szerokość, kolor samego tekstu z palety ANSI terminala (bez hexów/256/truecolor): czeka `3`, gotowe `2`, pracuje `4`, bezczynny `8`.
- **Agent**: stała szerokość, przy prawej krawędzi.
- Kursor (reverse) i pogrubienie okna z fokusem bez zmian. Sortowanie bez zmian (czeka → gotowe → pracuje → bezczynny, w grupie najstarszy na górze).
- Szerokości liczone `lipgloss.Width` (znaki szerokie). Bez nowych zależności (bez `lipgloss/table`).
- **Usunąć**: kolumny wiek i workspace (`age()`, `row.workspace`, `client.Workspace`) oraz sufiks `[#pid]` przy duplikatach (był dla dmenu; w TUI wybór kursorem). `since` zostaje (sortowanie), `focusHistoryID` zostaje (pogrubienie).

**Blocked by:** 02

**Status:** ready-for-agent

- [x] Kolumny wyrównane, nagłówek faint, status i agent zawsze przy prawej krawędzi
- [x] Gałąź: normalny HEAD, detached (sha), worktree, brak repo (`—`)
- [x] Folder/gałąź przycinane do 20/24 z `…`; message wypełnia resztę i znika w wąskim oknie
- [x] Kolory statusu z ANSI 2/3/4/8
- [x] Wiek, workspace i sufiks `[#pid]` usunięte razem z asercjami w `main_test.go`
- [x] `main_test.go`: test czystego parsera gałęzi (fixture'owe katalogi) — `go test` PASS
- [ ] E2E: kilka agentów w różnych repo/gałęziach → kolumny równe, kolory z motywu foot

## Comments

- Wąskie okno: po wyzerowaniu message kurczy się gałąź, potem folder — żeby status i agent zostały przy prawej krawędzi. Poniżej ~25 kolumn linia jest już po prostu obcinana z prawej.
- Obcinanie z `…` przez `ansi.Truncate` (`charmbracelet/x/ansi` — już był w grafie przez lipgloss, teraz direct w `go.mod`).
- Gałąź: obsłużony też submoduł (względny `gitdir:`); `ref:` spoza `refs/heads/` pokazywany w całości. Znany limit: repo reftable (HEAD = `.invalid`).
- Wiersz z kursorem: reverse zamienia kolor statusu w tło — do oceny przy E2E.
- E2E w foot niezrobione (render sprawdzony w testach tymczasowych na szerokościach 110/70/50/30/20 i na żywych agentach).
