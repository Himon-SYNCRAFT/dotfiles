package main

import (
	"os"
	"path/filepath"
	"reflect"
	"testing"
	"time"
)

func TestBuildRows(t *testing.T) {
	dir := t.TempDir()
	files := map[string]string{
		"a.json":      `{"agent":"claude","project":"dotfiles","event":"working","pid":101,"ts":500,"message":""}`,
		"b.json":      `{"agent":"claude","project":"dotfiles","event":"notify","pid":101,"ts":1000,"message":"Potrzebuję zgody"}`,
		"c.json":      `{"agent":"opencode","project":"web","event":"done","pid":301,"ts":900,"message":"gotowe"}`,
		"d.json":      `{"agent":"claude","project":"dotfiles","event":"working","pid":501,"ts":2000,"message":""}`,
		"e.json":      `{"agent":"pi","project":"api","event":"notify","pid":701,"ts":800,"message":""}`,
		"nested.json": `{"agent":"opencode","project":"dotfiles","event":"done","pid":101,"ts":1500,"message":"nested"}`, // nested agent's file: not the window's agent
		"stale.json":  `{"agent":"pi","project":"old","event":"done","pid":201,"ts":400,"message":"stale"}`,              // older than the pi now running there
		"orphan.json": `{"agent":"claude","project":"ghost","event":"notify","pid":999,"ts":1,"message":""}`,
		"broken.json": `{`,
	}
	for name, body := range files {
		if err := os.WriteFile(filepath.Join(dir, name), []byte(body), 0o644); err != nil {
			t.Fatal(err)
		}
	}

	at := func(s int64) time.Time { return time.Unix(s, 0) }
	procs := []proc{
		{pid: 1, ppid: 0, comm: "systemd"},
		{pid: 100, ppid: 1, comm: "foot"}, // footclient server: many windows
		{pid: 101, ppid: 100, comm: "fish"},
		{pid: 102, ppid: 101, comm: "claude", cwd: "/p/dotfiles", start: at(10)},
		{pid: 103, ppid: 102, comm: "opencode", cwd: "/p/dotfiles", start: at(20)}, // nested: same window, hidden
		{pid: 201, ppid: 100, comm: "fish"},
		{pid: 202, ppid: 201, comm: "pi", cwd: "/p/tools", start: at(500)}, // no state file → bezczynny
		{pid: 300, ppid: 1, comm: "foot"},                                  // standalone foot
		{pid: 301, ppid: 300, comm: "bash"},
		{pid: 302, ppid: 301, comm: "opencode", cwd: "/x/web", start: at(30)},
		{pid: 402, ppid: 1, comm: "claude", cwd: "/p/headless", start: at(40)}, // no foot → hidden
		{pid: 501, ppid: 100, comm: "fish"},
		{pid: 502, ppid: 501, comm: "claude", cwd: "/p/dotfiles", start: at(50)},
		{pid: 701, ppid: 100, comm: "fish"},
		{pid: 702, ppid: 701, comm: "pi", cwd: "/p/api", start: at(60)},
	}

	rows := buildRows(procs, readStates(dir))

	type got struct {
		shell         int
		label, status string
		since         int64
		message       string
	}
	var gs []got
	for _, r := range rows {
		gs = append(gs, got{r.shell, r.label, r.status, r.since.Unix(), r.message})
	}
	want := []got{
		{701, "pi · api", "czeka", 800, ""},
		{101, "claude · dotfiles [#101]", "czeka", 1000, "Potrzebuję zgody"},
		{301, "opencode · web", "gotowe", 900, "gotowe"},
		{501, "claude · dotfiles [#501]", "pracuje", 2000, ""},
		{201, "pi · tools", "bezczynny", 500, ""},
	}
	if !reflect.DeepEqual(gs, want) {
		t.Errorf("rows:\n got %+v\nwant %+v", gs, want)
	}
}
