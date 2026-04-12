local M = {}

local ns = vim.api.nvim_create_namespace("lightbulb")

-- Cache per buffer: { [bufnr] = { [line] = extmark_id } }
local cache = {}

local function clear_indicator(bufnr, line)
	if cache[bufnr] and cache[bufnr][line] then
		vim.api.nvim_buf_del_extmark(bufnr, ns, cache[bufnr][line])
		cache[bufnr][line] = nil
	end
end

local function set_indicator(bufnr, line)
	clear_indicator(bufnr, line)

	local id = vim.api.nvim_buf_set_extmark(bufnr, ns, line, -1, {
		virt_text = { { " 💡", "CodeActionVirtText" } }, -- ikona Nerd Font
		virt_text_pos = "eol",
		priority = 100,
	})

	if not cache[bufnr] then
		cache[bufnr] = {}
	end
	cache[bufnr][line] = id
end

local function check_code_actions()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = cursor[1] - 1 -- 0-indexed

	-- Sprawdź czy jakikolwiek klient wspiera codeAction
	local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
	if vim.tbl_isempty(clients) then
		clear_indicator(bufnr, line)
		return
	end

	local params = vim.lsp.util.make_range_params(0, "utf-8")
	params.context = {
		diagnostics = vim.diagnostic.get(bufnr, { lnum = line }),
		triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Automatic,
	}

	vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", params, function(results)
		local has_actions = false
		for _, result in pairs(results) do
			if result.result and not vim.tbl_isempty(result.result) then
				has_actions = true
				break
			end
		end

		-- Aktualizuj tylko jeśli bufor nadal istnieje
		if not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end

		if has_actions then
			set_indicator(bufnr, line)
		else
			clear_indicator(bufnr, line)
		end
	end)
end

function M.setup()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("code_action_indicator", { clear = true }),
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client or not client:supports_method("textDocument/codeAction") then
				return
			end

			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = ev.buf,
				callback = check_code_actions,
			})

			-- Wyczyść przy poruszeniu kursorem (opcjonalne — redukuje "migotanie")
			vim.api.nvim_create_autocmd("CursorMoved", {
				buffer = ev.buf,
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()
					if cache[bufnr] then
						for line, _ in pairs(cache[bufnr]) do
							-- Usuń tylko linie inne niż aktualna
							local cur_line = vim.api.nvim_win_get_cursor(0)[1] - 1
							if line ~= cur_line then
								clear_indicator(bufnr, line)
							end
						end
					end
				end,
			})

			-- Wyczyść przy detach
			vim.api.nvim_create_autocmd("LspDetach", {
				buffer = ev.buf,
				callback = function()
					vim.api.nvim_buf_clear_namespace(ev.buf, ns, 0, -1)
					cache[ev.buf] = nil
				end,
			})
		end,
	})
end

return M
