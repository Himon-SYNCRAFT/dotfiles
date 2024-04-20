require("luasnip.loaders.from_snipmate").lazy_load()
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda

vim.keymap.set({ "i" }, "<C-K>", function()
	ls.expand()
end, { silent = true })

-- vim.keymap.set({ "i", "s" }, "<Tab>", function()
-- 	ls.jump(1)
-- end, { silent = true })

-- vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
-- 	ls.jump(-1)
-- end, { silent = true })

-- vim.keymap.set({ "i", "s" }, "<C-E>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, { silent = true })
--
local function find_git_root()
	local path = vim.fn.expand("%:p:h")
	local root = nil
	while path ~= "/" and path ~= "" do
		if vim.fn.isdirectory(path .. "/.git") ~= 0 then
			root = path
			break
		end
		path = vim.fn.fnamemodify(path, ":h")
	end
	return root
end

local function get_namespace_for_src()
	local root = find_git_root()
	local file_path = root .. "/composer.json"
	local json = vim.fn.readfile(file_path)

	if #json == 0 then
		print("Nie znaleziono pliku composer.json")
		return ""
	end

	local json_content = table.concat(json, "")
	local ok, data = pcall(vim.fn.json_decode, json_content)

	if not ok or not data then
		print("Błąd przy dekodowaniu pliku composer.json")
		return ""
	end

	if data.autoload and data.autoload["psr-4"] then
		for namespace, path in pairs(data.autoload["psr-4"]) do
			if path == "src/" or path == "./src/" then
				return namespace
			end
		end
	end

	print("Nie znaleziono namespace dla src/ w composer.json")
	return ""
end

local function get_filename()
	local full_path = vim.fn.expand("%:p")
	local file_basename = vim.fn.fnamemodify(full_path, ":t:r")
	return file_basename
end

local function get_current_file_directory()
	local full_path = vim.fn.expand("%:p")
	local directory_path = vim.fn.fnamemodify(full_path, ":h")
	local directory_name = vim.fn.fnamemodify(directory_path, ":t")
	return directory_name
end

ls.add_snippets("php", {
	s("cl", {
		t({ "<?php", "" }),
		t({ "", "" }),
		t({ "declare(strict_types=1);", "" }),
		t({ "", "" }),
		t("namespace "),
		f(get_namespace_for_src),
		f(get_current_file_directory),
		t({ ";", "" }),
		t({ "", "" }),
		t("class "),
		f(get_filename),
		t({ "", "" }),
		t({ "{", "\t" }),
		i(1),
		t({ "", "" }),
		t({ "}" }),
	}),
	s("con", {
		t({ "public function __construct(" }),
		i(1),
		t({ ")", "" }),
		t({ "{", "\t" }),
		i(2),
		t({ "", "" }),
		t({ "}" }),
	}),
})
