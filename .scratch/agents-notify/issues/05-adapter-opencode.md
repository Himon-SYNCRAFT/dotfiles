# 05: Adapter opencode

**What to build:** Prawdziwy agent opencode podpięty pod kręgosłup, E2E. Plugin w katalogu pluginów opencode (pakiet stow `agents/`) woła wspólny `agent-hook`: `permission.updated` → notify, `session.idle` → done, `session.status` busy → working, `session.deleted` → clear. Payloady eventów zweryfikowane z typów SDK zainstalowanej wersji (`properties.sessionID`). Instancje przez `ai opencode`. Ryzyko jak w 04: PPID-łańcuch z procesu opencode do foot — zweryfikować E2E, udokumentować obejście jeśli nie działa.

**Blocked by:** 01 (kręgosłup — agent-hook, ai, focus-window).

**Status:** ready-for-agent

- [ ] `ai opencode` działa; zdarzenia mapują się na working/notify/done/clear
- [ ] `permission.updated` → notify + powiadomienie critical; klik focusuje okno
- [ ] `session.idle` → done; `session.status` busy → working; `session.deleted` → clear
- [ ] PPID-walk z pluginu działa albo obejście udokumentowane w Comments
- [ ] Plugin jest częścią pakietu stow `agents/` — zgodnie ze spec
