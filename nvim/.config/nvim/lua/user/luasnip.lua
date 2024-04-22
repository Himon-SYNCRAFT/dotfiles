require("luasnip.loaders.from_snipmate").lazy_load()
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local postfix = require("luasnip.extras.postfix").postfix

ls.config.setup({
	enable_autosnippets = true,
})

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

local function firstToLower(values)
	local str = values[1][1]
	if str == nil or str == "" then
		return str
	end
	return str:sub(1, 1):lower() .. str:sub(2)
end

ls.add_snippets("php", {
	s(
		"cl",
		fmt(
			[[
            <?php

            declare(strict_types=1);

            namespace `root#`namespace#;

            class `class_name#
            {
                `class_content#
            }
            ]],
			{
				root = f(get_namespace_for_src),
				namespace = f(get_current_file_directory),
				class_name = f(get_filename),
				class_content = i(1),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"get",
		fmt(
			[[
            public function get`name#(): `typ#
            {
                return $this->`lowercased_name#;
            }
            ]],
			{
				name = i(1, "Name"),
				typ = i(2, "Type"),
				lowercased_name = f(firstToLower, { 1 }),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"con",
		fmt(
			[[
		public function __construct(
			`#
		) {
		}
		]],
			{
				i(1),
			},
			{ delimiters = "`#" }
		)
	),
	s(
		"set",
		fmt(
			[[
            public function set`name#(`typ# $`lowercased_name#): self
            {
                $this->`lowercased_name# = $`lowercased_name#;
                return $this;
            }
            ]],
			{
				name = i(1, "Name"),
				typ = i(2, "Type"),
				lowercased_name = f(firstToLower, { 1 }),
			},
			{ delimiters = "`#" }
		)
	),
	postfix({
		trig = ".var",
		match_pattern = "^%s*(.*)",
		snippetType = "autosnippet",
	}, {
		d(1, function(_, parent)
			return sn(1, fmt("${} = " .. parent.snippet.env.POSTFIX_MATCH, { i(1, "name") }))
		end),
	}),
})
