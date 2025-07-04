local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local l = require("luasnip.extras").lambda
-- local sn = ls.snippet_node
-- local t = ls.text_node

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
var i = {i};

while ({condition}) : ({step}) {{
    {body}
}}
            ]],
			{
				i = i(1, "i"),
				condition = i(2, "i < 10"),
				step = i(3, "i += 1"),
				body = i(4),
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
				condition = i(1),
				body = i(2),
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
				body = i(4),
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
