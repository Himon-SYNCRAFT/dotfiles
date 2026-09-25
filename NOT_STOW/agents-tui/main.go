// agents-tui — live list of AI agents (claude, opencode, pi) running in foot
// windows, with status from agent-hook state files; Enter focuses the window.
//
// Build (from the repo root; own module, hence -C):
//
//	go build -C NOT_STOW/agents-tui -o ~/.local/bin/agents-tui .
//
// Read-only: processes (/proc) say which agents exist, state files
// ($XDG_RUNTIME_DIR/agents/*.json) only add status. Nothing is written or pruned.
package main

import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"strconv"
	"strings"
	"time"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
)

// Agents are recognised by /proc/<pid>/comm: all three ship as native
// binaries named after themselves (verified live, see issue 01 Comments).
var agentComms = map[string]bool{"claude": true, "opencode": true, "pi": true}

type proc struct {
	pid, ppid int
	comm, cwd string
	start     time.Time
}

type state struct {
	Agent   string `json:"agent"`
	Project string `json:"project"`
	Event   string `json:"event"`
	PID     int    `json:"pid"`
	TS      int64  `json:"ts"`
	Message string `json:"message"`
}

type row struct {
	shell                           int // window's shell pid (direct child of foot)
	agent, project, status, message string
	since                           time.Time
	label                           string
}

var statusRank = map[string]int{"czeka": 0, "gotowe": 1, "pracuje": 2, "bezczynny": 3}
var eventStatus = map[string]string{"notify": "czeka", "done": "gotowe", "working": "pracuje"}

// buildRows: one row per foot window, for the agent nearest foot; agents with
// no foot ancestor are dropped. Status joins on the shell pid + agent name
// (adapters pass the same name as comm), newest file wins; files older than
// the process are a previous session in that window (no clear hook) → ignored.
func buildRows(procs []proc, states []state) []row {
	byPID := make(map[int]proc, len(procs))
	for _, p := range procs {
		byPID[p.pid] = p
	}

	var rows []row
	for _, p := range procs {
		if !agentComms[p.comm] {
			continue
		}
		// Same walk as agent-hook: up the PPID chain to foot's direct child.
		// An agent ancestor on the way means that one represents the window.
		shell, cur, nested := 0, p, false
		for {
			parent, ok := byPID[cur.ppid]
			if !ok {
				break
			}
			if parent.comm == "foot" {
				shell = cur.pid
				break
			}
			if agentComms[parent.comm] {
				nested = true
				break
			}
			cur = parent
		}
		if shell == 0 || nested {
			continue
		}

		r := row{shell: shell, agent: p.comm, project: filepath.Base(p.cwd), status: "bezczynny", since: p.start}
		var best *state
		for i, s := range states {
			if s.PID == shell && s.Agent == p.comm && s.TS >= p.start.Unix() &&
				eventStatus[s.Event] != "" && (best == nil || s.TS > best.TS) {
				best = &states[i]
			}
		}
		if best != nil {
			r.status, r.since, r.message = eventStatus[best.Event], time.Unix(best.TS, 0), best.Message
			if best.Project != "" {
				r.project = best.Project
			}
		}
		rows = append(rows, r)
	}

	// Duplicate labels get the window pid, as in agents-pick.
	count := map[string]int{}
	for i := range rows {
		rows[i].label = rows[i].agent + " · " + rows[i].project
		count[rows[i].label]++
	}
	for i := range rows {
		if count[rows[i].label] > 1 {
			rows[i].label += fmt.Sprintf(" [#%d]", rows[i].shell)
		}
	}

	sort.Slice(rows, func(i, j int) bool {
		a, b := rows[i], rows[j]
		if statusRank[a.status] != statusRank[b.status] {
			return statusRank[a.status] < statusRank[b.status]
		}
		if !a.since.Equal(b.since) {
			return a.since.Before(b.since)
		}
		return a.shell < b.shell
	})
	return rows
}

// readStates: unreadable/broken files are skipped (a writer may be mid-rename).
func readStates(dir string) []state {
	paths, _ := filepath.Glob(filepath.Join(dir, "*.json"))
	var out []state
	for _, p := range paths {
		b, err := os.ReadFile(p)
		if err != nil {
			continue
		}
		var s state
		if json.Unmarshal(b, &s) == nil {
			out = append(out, s)
		}
	}
	return out
}

// scanProcs reads comm/ppid/start for every process; cwd only for agents.
// ponytail: CLK_TCK assumed 100 (Linux default), no cgo sysconf.
func scanProcs() []proc {
	var boot int64
	if b, err := os.ReadFile("/proc/stat"); err == nil {
		for _, l := range strings.Split(string(b), "\n") {
			if v, ok := strings.CutPrefix(l, "btime "); ok {
				boot, _ = strconv.ParseInt(v, 10, 64)
			}
		}
	}
	ents, _ := os.ReadDir("/proc")
	var out []proc
	for _, e := range ents {
		pid, err := strconv.Atoi(e.Name())
		if err != nil {
			continue
		}
		b, err := os.ReadFile("/proc/" + e.Name() + "/stat")
		if err != nil {
			continue
		}
		// "pid (comm) state ppid ... starttime(22nd)"; comm may contain spaces/parens.
		s := string(b)
		open, end := strings.IndexByte(s, '('), strings.LastIndexByte(s, ')')
		if open < 0 || end < open {
			continue
		}
		f := strings.Fields(s[end+1:])
		if len(f) < 20 {
			continue
		}
		p := proc{pid: pid, comm: s[open+1 : end]}
		p.ppid, _ = strconv.Atoi(f[1])
		ticks, _ := strconv.ParseInt(f[19], 10, 64)
		p.start = time.Unix(boot+ticks/100, 0)
		if agentComms[p.comm] {
			p.cwd, _ = os.Readlink("/proc/" + e.Name() + "/cwd")
		}
		out = append(out, p)
	}
	return out
}

func stateDir() string {
	d := os.Getenv("XDG_RUNTIME_DIR")
	if d == "" {
		d = fmt.Sprintf("/run/user/%d", os.Getuid())
	}
	return filepath.Join(d, "agents")
}

type tickMsg time.Time

func tick() tea.Cmd { return tea.Tick(time.Second, func(t time.Time) tea.Msg { return tickMsg(t) }) }

type model struct {
	rows   []row
	cursor int
	width  int
}

func (m *model) refresh() {
	sel := 0
	if m.cursor < len(m.rows) {
		sel = m.rows[m.cursor].shell
	}
	m.rows = buildRows(scanProcs(), readStates(stateDir()))
	m.cursor = min(m.cursor, max(len(m.rows)-1, 0))
	for i, r := range m.rows { // keep the selection on the same window
		if r.shell == sel {
			m.cursor = i
		}
	}
}

func (m model) Init() tea.Cmd { return tick() }

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tickMsg:
		m.refresh()
		return m, tick()
	case tea.WindowSizeMsg:
		m.width = msg.Width
	case tea.KeyMsg:
		switch msg.String() {
		case "q", "ctrl+c":
			return m, tea.Quit
		case "j", "down":
			m.cursor = min(m.cursor+1, max(len(m.rows)-1, 0))
		case "k", "up":
			m.cursor = max(m.cursor-1, 0)
		case "enter":
			if m.cursor < len(m.rows) {
				cmd := exec.Command("focus-window", strconv.Itoa(m.rows[m.cursor].shell))
				if cmd.Start() == nil {
					go cmd.Wait() // reap; the TUI stays open
				}
			}
		}
	}
	return m, nil
}

var (
	lineStyle = lipgloss.NewStyle()
	selStyle  = lipgloss.NewStyle().Reverse(true)
)

func age(d time.Duration) string {
	switch {
	case d < time.Minute:
		return fmt.Sprintf("%ds", int(d.Seconds()))
	case d < time.Hour:
		return fmt.Sprintf("%dm", int(d.Minutes()))
	case d < 24*time.Hour:
		return fmt.Sprintf("%dh", int(d.Hours()))
	}
	return fmt.Sprintf("%dd", int(d.Hours()/24))
}

func (m model) View() string {
	if len(m.rows) == 0 {
		return "brak agentów\n"
	}
	var b strings.Builder
	for i, r := range m.rows {
		parts := []string{r.label, r.status, age(time.Since(r.since))}
		if r.message != "" {
			parts = append(parts, strings.Join(strings.Fields(r.message), " "))
		}
		st := lineStyle
		if i == m.cursor {
			st = selStyle
		}
		if m.width > 0 {
			st = st.MaxWidth(m.width)
		}
		b.WriteString(st.Render(strings.Join(parts, " · ")) + "\n")
	}
	return b.String()
}

func main() {
	m := model{}
	m.refresh()
	if _, err := tea.NewProgram(m, tea.WithAltScreen()).Run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
