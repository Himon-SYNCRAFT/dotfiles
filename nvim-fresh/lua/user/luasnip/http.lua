local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("http", {
	s(
		"get",
		fmt(
			[[
        ### {}
        GET {} HTTP/1.1
        Host: {}
        Accept: application/json

        ]],
			{
				i(1, "Opis zapytania GET"),
				i(2, "/api/endpoint"),
				i(3, "localhost:8000"),
			}
		)
	),

	s(
		"post",
		fmt(
			[[
        ### {}
        POST {} HTTP/1.1
        Host: {}
        Content-Type: application/json
        Accept: application/json

        {{
          "{}": "{}"
        }}

        ]],
			{
				i(1, "Opis zapytania POST"),
				i(2, "/api/endpoint"),
				i(3, "localhost:8000"),
				i(4, "key"),
				i(5, "value"),
			}
		)
	),

	s(
		"put",
		fmt(
			[[
        ### {}
        PUT {} HTTP/1.1
        Host: {}
        Content-Type: application/json
        Accept: application/json

        {{
          "{}": "{}"
        }}

        ]],
			{
				i(1, "Opis PUT"),
				i(2, "/api/endpoint"),
				i(3, "localhost:8000"),
				i(4, "key"),
				i(5, "value"),
			}
		)
	),

	s(
		"patch",
		fmt(
			[[
        ### {}
        PATCH {} HTTP/1.1
        Host: {}
        Content-Type: application/json
        Accept: application/json

        {{
          "{}": "{}"
        }}

        ]],
			{
				i(1, "Opis PATCH"),
				i(2, "/api/endpoint"),
				i(3, "localhost:8000"),
				i(4, "key"),
				i(5, "value"),
			}
		)
	),

	s(
		"delete",
		fmt(
			[[
        ### {}
        DELETE {} HTTP/1.1
        Host: {}
        Accept: application/json

        ]],
			{
				i(1, "Opis DELETE"),
				i(2, "/api/endpoint"),
				i(3, "localhost:8000"),
			}
		)
	),

	s(
		"options",
		fmt(
			[[
        ### {}
        OPTIONS {} HTTP/1.1
        Host: {}
        Accept: */*

        ]],
			{
				i(1, "Zapytanie OPTIONS"),
				i(2, "/api/endpoint"),
				i(3, "localhost:8000"),
			}
		)
	),
})
