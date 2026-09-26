// agents-tui — live list of AI agents (claude, opencode, pi) running in foot
// windows, with status from agent-hook state files; Enter focuses the window.
//
// Build (from the repo root; own module, hence -C):
//
//	go build -C NOT_STOW/agents-tui -o ~/.local/bin/agents-tui .
//
// Read-only: processes (/proc) say which agents exist, state files
// ($XDG_RUNTIME_DIR/agents/*.json) only add status, `hyprctl clients` adds
// the window (focus, title). Nothing is written or pruned on disk;
// the only write is a one-off title marker into each new agent window's pty.
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
	"github.com/charmbracelet/x/ansi"
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
	shell                                   int // window's shell pid (direct child of foot)
	agent, project, branch, status, message string
	since                                   time.Time
	focused                                 bool
}

type client struct {
	Address        string `json:"address"`
	Title          string `json:"title"`
	FocusHistoryID int    `json:"focusHistoryID"`
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

		r := row{shell: shell, agent: p.comm, project: filepath.Base(p.cwd), branch: gitBranch(p.cwd), status: "bezczynny", since: p.start}
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

// addWindows fills window data from Hyprland clients via the shell → address
// map; no address (or window gone) leaves the row without it. The window
// title stands in for a missing message.
func addWindows(rows []row, clients []client, addrs map[int]string) []row {
	byAddr := make(map[string]client, len(clients))
	for _, c := range clients {
		byAddr[c.Address] = c
	}
	for i := range rows {
		c, ok := byAddr[addrs[rows[i].shell]]
		if !ok {
			continue
		}
		rows[i].focused = c.FocusHistoryID == 0
		if rows[i].message == "" {
			rows[i].message = c.Title
		}
	}
	return rows
}

func parseClients(b []byte) ([]client, error) {
	var cs []client
	return cs, json.Unmarshal(b, &cs)
}

func hyprClients() []client {
	b, err := exec.Command("hyprctl", "clients", "-j").Output()
	if err != nil {
		return nil
	}
	cs, _ := parseClients(b)
	return cs
}

// resolveAddrs maps each new shell to its window address with focus-window's
// trick (footclient windows share the foot pid, so Hyprland can't tell them
// apart): push title, OSC 2 marker into the shell's pty, find it in
// `hyprctl clients`, pop title. All new shells in one batch; a miss is stored
// as "" so it's never retried. Shells no longer listed are dropped.
// ponytail: blocks the UI up to 1 s while a marker is pending (move to a
// tea.Cmd if that ever shows); the marker write can interleave with the
// agent's TUI output, and an agent retitling within those ms makes a miss.
func resolveAddrs(addrs map[int]string, shells []int) {
	live := make(map[int]bool, len(shells))
	pending := map[string]int{} // marker → shell
	ptys := map[int]*os.File{}
	pop := func(sh int) {
		ptys[sh].WriteString("\x1b[23;0t")
		ptys[sh].Close()
	}
	for _, sh := range shells {
		live[sh] = true
		if _, ok := addrs[sh]; ok {
			continue
		}
		addrs[sh] = ""
		tty, _ := os.Readlink(fmt.Sprintf("/proc/%d/fd/0", sh))
		if !strings.HasPrefix(tty, "/dev/pts/") {
			continue
		}
		f, err := os.OpenFile(tty, os.O_WRONLY, 0)
		if err != nil {
			continue
		}
		marker := fmt.Sprintf("agents-tui-%d-%d", os.Getpid(), sh) // per instance
		if _, err := fmt.Fprintf(f, "\x1b[22;0t\x1b]2;%s\a", marker); err != nil {
			f.Close()
			continue
		}
		pending[marker], ptys[sh] = sh, f
	}
	for sh := range addrs {
		if !live[sh] {
			delete(addrs, sh)
		}
	}
	for i := 0; i < 20 && len(pending) > 0; i++ {
		if i > 0 {
			time.Sleep(50 * time.Millisecond)
		}
		for _, c := range hyprClients() {
			if sh, ok := pending[c.Title]; ok {
				addrs[sh] = c.Address
				pop(sh)
				delete(pending, c.Title)
			}
		}
	}
	for _, sh := range pending {
		pop(sh)
	}
}

// gitBranch reads HEAD of the repo containing dir, walking up, without
// running git. `.git` may be a file `gitdir: …` (worktree, submodule).
// Outside a repo "—", detached HEAD → short sha.
func gitBranch(dir string) string {
	if dir == "" { // unreadable /proc/<pid>/cwd; "" would mean the TUI's own cwd
		return "—"
	}
	for {
		gd := filepath.Join(dir, ".git")
		if b, err := os.ReadFile(gd); err == nil { // a file, not a dir
			if v, ok := strings.CutPrefix(strings.TrimSpace(string(b)), "gitdir: "); ok {
				gd = v
				if !filepath.IsAbs(gd) {
					gd = filepath.Join(dir, gd)
				}
			}
		}
		if b, err := os.ReadFile(filepath.Join(gd, "HEAD")); err == nil {
			head := strings.TrimSpace(string(b))
			// ponytail: reftable repos keep the real HEAD in the table and show
			// ".invalid" here; read reftable if one ever shows up.
			if ref, ok := strings.CutPrefix(head, "ref: "); ok {
				return strings.TrimPrefix(ref, "refs/heads/")
			}
			return head[:min(7, len(head))]
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			return "—"
		}
		dir = parent
	}
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
	addrs  map[int]string // window shell pid → Hyprland address
	rows   []row
	cursor int
	width  int
}

func (m *model) refresh() {
	sel := 0
	if m.cursor < len(m.rows) {
		sel = m.rows[m.cursor].shell
	}
	// Clients first: a window just marked still shows the marker title until
	// Hyprland sees the pop; it gets its data on the next tick.
	clients := hyprClients()
	rows := buildRows(scanProcs(), readStates(stateDir()))
	// Mark only windows already listed last tick: a just-started agent sets
	// its own title right away and would race the marker.
	prev := map[int]bool{}
	for _, r := range m.rows {
		prev[r.shell] = true
	}
	var shells []int
	for _, r := range rows {
		if prev[r.shell] {
			shells = append(shells, r.shell)
		}
	}
	resolveAddrs(m.addrs, shells)
	m.rows = addWindows(rows, clients, m.addrs)
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

// Terminal palette indexes (0–15), so colours follow the foot theme.
var statusColor = map[string]lipgloss.Color{"czeka": "3", "gotowe": "2", "pracuje": "4", "bezczynny": "8"}

// cell cuts s to w cells with "…" and pads it to exactly w.
func cell(s string, w int) string {
	s = ansi.Truncate(s, w, "…")
	return s + strings.Repeat(" ", w-lipgloss.Width(s))
}

// View: FOLDER | GAŁĄŹ | MESSAGE | STATUS | AGENT. Folder and branch fit the
// longest value (capped), status and agent are fixed; message takes the rest
// and is the first to shrink, down to nothing.
func (m model) View() string {
	if len(m.rows) == 0 {
		return "brak agentów\n"
	}
	const gap = "  "
	statusW, agentW := len("bezczynny"), len("opencode")
	folderW, branchW := len("FOLDER"), lipgloss.Width("GAŁĄŹ")
	for _, r := range m.rows {
		folderW, branchW = max(folderW, lipgloss.Width(r.project)), max(branchW, lipgloss.Width(r.branch))
	}
	folderW, branchW = min(folderW, 20), min(branchW, 24)
	msgW := m.width - folderW - branchW - statusW - agentW - 4*len(gap)
	if m.width > 0 && msgW < 0 { // then branch, then folder, to keep status/agent visible
		cut := min(-msgW, branchW)
		branchW, folderW = branchW-cut, max(folderW+msgW+cut, 0)
	}
	msgW = max(msgW, 0)

	var b strings.Builder
	// Status is rendered on its own for the colour, so every segment carries
	// the row's style (a reset after the status would end reverse/bold).
	line := func(st, statusSt lipgloss.Style, folder, branch, msg, status, agent string) {
		l := st.Render(cell(folder, folderW)+gap+cell(branch, branchW)+gap+cell(msg, msgW)+gap) +
			statusSt.Render(cell(status, statusW)) + st.Render(gap+cell(agent, agentW))
		if m.width > 0 {
			l = lipgloss.NewStyle().MaxWidth(m.width).Render(l)
		}
		b.WriteString(l + "\n")
	}
	faint := lipgloss.NewStyle().Faint(true)
	line(faint, faint, "FOLDER", "GAŁĄŹ", "MESSAGE", "STATUS", "AGENT")
	for i, r := range m.rows {
		st := lipgloss.NewStyle().Reverse(i == m.cursor).Bold(r.focused)
		line(st, st.Foreground(statusColor[r.status]), r.project, r.branch,
			strings.Join(strings.Fields(r.message), " "), r.status, r.agent)
	}
	return b.String()
}

func main() {
	m := model{addrs: map[int]string{}}
	m.refresh()
	if _, err := tea.NewProgram(m, tea.WithAltScreen()).Run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
