-- lua/statusline.lua
-- vim.lsp.status() zastępuje fidget.nvim
local modes = {
	["n"] = "NORMAL",
	["no"] = "NORMAL",
	["v"] = "VISUAL",
	["V"] = "VISUAL LINE",
	[""] = "VISUAL BLOCK",
	["s"] = "SELECT",
	["S"] = "SELECT LINE",
	[""] = "SELECT BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "REPLACE",
	["Rv"] = "VISUAL REPLACE",
	["c"] = "COMMAND",
	["cv"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

local function mode()
	local current_mode = vim.api.nvim_get_mode().mode
	return string.format(" %s ", modes[current_mode] or current_mode):upper()
end

local function filename()
	local fname = vim.fn.expand("%:t")
	if fname == "" then
		fname = "- No Name -"
	end
	if vim.bo.modifiable == false or vim.bo.readonly then
		fname = "󰌾 " .. fname
	end
	if vim.bo.modified then
		fname = "󰧞 " .. fname
	end
	return " " .. fname .. " "
end

local function lsp_progress()
	local status = vim.lsp.status()
	if status and status ~= "" then
		return " " .. status .. " "
	end
	return ""
end

local function lsp()
	local count = {}
	local levels = { errors = "Error", warnings = "Warn", info = "Info", hints = "Hint" }
	for k, level in pairs(levels) do
		count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
	end
	return " %#StatusLineErrSign#󰅙 "
		.. count["errors"]
		.. " %#StatusLineWarnSign#󰀦 "
		.. count["warnings"]
		.. " %#StatusLineInfoSign#󰀨 "
		.. count["info"]
		.. " %#StatusLineHintSign#󰌵 "
		.. count["hints"]
end

local function lineinfo()
	if vim.bo.filetype == "alpha" then
		return ""
	end
	return " %l/%L: %c "
end

Statusline = {}

Statusline.active = function()
	return table.concat({
		"%#Statusline#",
		mode(),
		-- lsp_progress(),
		lsp(),
		" ",
		"%#Statusline#",
		filename(),
		"%=%#StatusLine#",
		lineinfo(),
	})
end

function Statusline.inactive()
	return " %F"
end

vim.api.nvim_exec(
	[[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
    augroup END
]],
	false
)
