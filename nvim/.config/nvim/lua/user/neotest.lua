require("neotest-phpunit")({
	phpunit_cmd = function()
		return { "vendor/bin/phpunit" }
	end,
	filter_dirs = { ".git", "node_modules", "vendor" },
})

vim.diagnostic.config({ virtual_text = true }, vim.api.nvim_create_namespace("neotest"))
