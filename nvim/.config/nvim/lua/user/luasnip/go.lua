local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local postfix = require("luasnip.extras.postfix").postfix
-- local t = ls.text_node
-- local r = ls.restore_node
-- local l = require("luasnip.extras").lambda
-- local c = ls.choice_node

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

ls.add_snippets("go", {
	s(
		"repo",

		fmt(
			[[
package repository

import (
	"context"
	"database/sql"

	. "github.com/go-jet/jet/v2/postgres" //nolint:staticcheck

	"gitlab.com/syncraft-pl/sisyphus/internal/db/gen/sisyphus/public/model"
	. "gitlab.com/syncraft-pl/sisyphus/internal/db/gen/sisyphus/public/table" //nolint:staticcheck
	"gitlab.com/syncraft-pl/sisyphus/internal/domain"
)

type @entity#Repository interface {
	Repository[domain.@entity#]
}

type @lowercased_entity#Repository struct {
	BaseRepo[domain.@entity#]
}

func New@entity#Repository() @entity#Repository {
	return &@lowercased_entity#Repository{}
}

func (r *@lowercased_entity#Repository) Create(
	ctx context.Context,
	tx *sql.Tx,
	entity *domain.@entity#,
) (*domain.@entity#, error) {
	if err := r.validate(entity, tx); err != nil {
		return nil, err
	}

	var dest []struct {
		ID int32 `sql:"primary_key"`
	}

	stmt := @entity#s.INSERT(
		@entity#s.MutableColumns,
	).MODEL(
		model.@entity#s{
			Name: entity.Name,
		},
	).RETURNING(
		@entity#s.ID.AS("ID"),
	)

	err := stmt.QueryContext(ctx, tx, &dest)
	if err != nil {
		return nil, err
	}

	if len(dest) == 0 {
		return nil, ErrIDNotReturned
	}

	if dest[0].ID == 0 {
		return nil, ErrIDNotReturned
	}

	entity.ID = dest[0].ID
	return entity, nil
}

func (r *@lowercased_entity#Repository) Update(
	ctx context.Context,
	tx *sql.Tx,
	entity *domain.@entity#,
) (*domain.@entity#, error) {
	if err := r.validate(entity, tx); err != nil {
		return nil, err
	}

	_, err := @entity#s.UPDATE(@entity#s.MutableColumns).MODEL(model.@entity#s{
		Name: entity.Name,
	}).WHERE(@entity#s.ID.EQ(Int32(entity.ID))).
		ExecContext(ctx, tx)
	if err != nil {
		return nil, err
	}

	return entity, nil
}

func (r *@lowercased_entity#Repository) FindByID(
	ctx context.Context,
	tx *sql.Tx,
	id int32,
) (*domain.@entity#, error) {
	var dest struct {
		model.@entity#s
	}

	err := @entity#s.SELECT(
		@entity#s.AllColumns,
	).WHERE(
		@entity#s.ID.EQ(Int32(id)),
	).QueryContext(
		ctx, tx, &dest,
	)
	if err != nil {
		return nil, err
	}

	if dest.ID == 0 {
		return nil, ErrNotFound
	}

	entity := domain.@entity#{
		ID:   int32(dest.ID),
		Name: dest.Name,
	}

	return &entity, nil
}

func (r *@lowercased_entity#Repository) DeleteByID(
	ctx context.Context,
	tx *sql.Tx,
	id int32,
) error {
	_, err := @entity#s.DELETE().
		WHERE(
			@entity#s.ID.EQ(Int32(id)),
		).
		ExecContext(ctx, tx)
	if err != nil {
		return err
	}

	return nil
}
            ]],
			{
				entity = i(1, "Entity"),
				lowercased_entity = f(first_to_lower, { 1 }),
			},
			{ delimiters = "@#" }
		)
	),
})
