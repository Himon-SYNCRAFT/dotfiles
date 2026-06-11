local M = {}

local uv = vim.loop
local sigusr1 = uv.new_signal()

function M.get_theme_mode()
	local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme")

	if not handle then
		return "dark"
	end

	local result = handle:read("*a")
	handle:close()

	if result:match("prefer%-light") then
		return "light"
	end

	return "dark"
end

function M.reload_theme(background)
	vim.schedule(function()
		vim.o.background = background

		vim.cmd("highlight clear")

		if vim.fn.exists("syntax_on") == 1 then
			vim.cmd("syntax reset")
		end

		package.loaded["plugins.theme"] = nil
		require("plugins.theme")

		vim.cmd("redraw!")

		vim.notify("Theme changed to: " .. background)
	end)
end

function M.setup()
	-- ustaw background jak najwcześniej
	vim.o.background = M.get_theme_mode()

	sigusr1:start(10, function()
		local mode = M.get_theme_mode()
		M.reload_theme(mode)
	end)
end

return M
