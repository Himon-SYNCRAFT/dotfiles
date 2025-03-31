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

local function first_to_lower(values)
	local str = values[1][1]
	if str == nil or str == "" then
		return str
	end
	return str:sub(1, 1):lower() .. str:sub(2)
end

local function get_first_letter_lowercase(values)
	local str = values[1][1]
	if str == nil or str == "" then
		return ""
	end
	return str:sub(1, 1):lower()
end

local function get_namespace()
	local buf = vim.api.nvim_get_current_buf()
	local filepath = vim.api.nvim_buf_get_name(buf)
	local src_start = filepath:find("src/")

	if src_start then
		local start_pos = src_start + #"src/"

		local last_slash = filepath:match(".*()/")

		if last_slash and last_slash > start_pos then
			local subpath = filepath:sub(start_pos, last_slash - 1)
			return subpath:gsub("/", "\\")
		else
			return ""
		end
	else
		return filepath
	end
end

ls.add_snippets("zig", {
	-- Tworzenie zmiennej
	s(
		"const",
		fmt(
			[[
const {name} = {value};
            ]],
			{
				name = i(1, "name"),
				value = i(2, "value"),
			},
			{ delimiters = "{}" }
		)
	),
	s(
		"var",
		fmt(
			[[
var {name} = {value};
            ]],
			{
				name = i(1, "name"),
				value = i(2, "value"),
			},
			{ delimiters = "{}" }
		)
	),

	s(
		"fori",
		fmt(
			[[
for ({i} := 0; {i} < {n}; {i} += 1) {{
    {body}
}}
            ]],
			{
				i = i(1, "i"),
				n = i(2, "n"),
				body = i(3),
			},
			{ delimiters = "{}" }
		)
	),

	s(
		"for",
		fmt(
			[[
for ({items}) |{value}| {{
    {body}
}}
            ]],
			{
				items = i(1, "items"),
				value = i(2, "value"),
				body = i(3),
			},
			{ delimiters = "{}" }
		)
	),

	s(
		"forr",
		fmt(
			[[
for (&{items}) |*{value}| {{
    {body}
}}
            ]],
			{
				items = i(1, "items"),
				value = i(2, "value"),
				body = i(3),
			},
			{ delimiters = "{}" }
		)
	),

	s(
		"forelse",
		fmt(
			[[
for ({items}) |{value}| {{
    {body}
}} else {else_body}
            ]],
			{
				items = i(1, "items"),
				value = i(2, "value"),
				body = i(3),
				else_body = i(4),
			},
			{ delimiters = "{}" }
		)
	),

	s(
		"fore",
		fmt(
			[[
for ({items}, 0..) |{value}, i| {{
    {body}
}}
            ]],
			{
				items = i(1, "items"),
				value = i(2, "value"),
				body = i(3),
			},
			{ delimiters = "{}" }
		)
	),

	-- Tworzenie pętli (while loop)
	s(
		"while",
		fmt(
			[[
while ({condition}) {{
    {body}
}}
            ]],
			{
				condition = i(1, "condition"),
				body = i(2, "// loop body"),
			},
			{ delimiters = "{}" }
		)
	),

	-- Warunki (if, if-else, if-else-if)
	s(
		"if",
		fmt(
			[[
if ({condition}) {{
    {body}
}}
            ]],
			{
				condition = i(1, "condition"),
				body = i(2),
			},
			{ delimiters = "{}" }
		)
	),
	s(
		"ifelse",
		fmt(
			[[
if ({condition}) {{
    {if_body}
}} else {{
    {else_body}
}}
            ]],
			{
				condition = i(1, "condition"),
				if_body = i(2),
				else_body = i(3),
			},
			{ delimiters = "{}" }
		)
	),
	s(
		"ifelseifelse",
		fmt(
			[[
if ({condition1}) {{
    {if_body}
}} else if ({condition2}) {{
    {elseif_body}
}} else {{
    {else_body}
}}
            ]],
			{
				condition1 = i(1, "condition1"),
				if_body = i(2),
				condition2 = i(3),
				elseif_body = i(4),
				else_body = i(5),
			},
			{ delimiters = "{}" }
		)
	),

	-- Tworzenie funkcji (publiczna, prywatna)
	s(
		"pubfn",
		fmt(
			[[
pub fn {name}({args}) {return_type} {{
    {body}
}}
            ]],
			{
				name = i(1, "functionName"),
				args = i(2, "args"),
				return_type = i(3, "returnType"),
				body = i(4),
			},
			{ delimiters = "{}" }
		)
	),
	s(
		"privfn",
		fmt(
			[[
fn {name}({args}) {return_type} {{
    {body}
}}
            ]],
			{
				name = i(1, "functionName"),
				args = i(2, "args"),
				return_type = i(3, "returnType"),
				body = i(4, "// function body"),
			},
			{ delimiters = "{}" }
		)
	),

	s(
		"switch",
		fmt(
			[[
switch ({value}) {{
    {case1} => {{
        {case1_body}
    }},
    else => {{
        {default_body}
    }}
}}
            ]],
			{
				value = i(1, "value"),
				case1 = i(2, "case"),
				case1_body = i(3),
				default_body = i(4),
			},
			{ delimiters = "{}" }
		)
	),
})
