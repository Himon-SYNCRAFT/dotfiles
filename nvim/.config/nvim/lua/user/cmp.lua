local cmp = require("cmp")
local feedkeys = require("cmp.utils.feedkeys")
local keymap = require("cmp.utils.keymap")
local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local kind_icons = {
	Text = "",
	Method = "",
	Function = "󰊕",
	Constructor = "",
	Field = "󰭷",
	Variable = "󰫧",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰓹",
	Unit = "",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "",
	Event = "",
	Operator = "󱓉",
	TypeParameter = "",
	Codeium = "",
}

local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	formatting = {
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			-- vim_item.kind = string.format('%s ', kind_icons[vim_item.kind])
			-- Source
			-- vim_item.menu = ({
			--     buffer = "[Buffer]",
			--     nvim_lsp = "[LSP]",
			--     luasnip = "[LuaSnip]",
			--     ultisnips = "[Snip]",
			--     nvim_lua = "[Lua]",
			--     latex_symbols = "[LaTeX]"
			-- })[entry.source.name]
			return vim_item
		end,
	},

	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
		end, {
			"i",
			"s" --[[ "c" (to enable the mapping in command mode) ]],
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			cmp_ultisnips_mappings.jump_backwards(fallback)
		end, {
			"i",
			"s" --[[ "c" (to enable the mapping in command mode) ]],
		}),
		-- ["<Tab>"] = cmp.mapping({
		--     i = function(fallback)
		--         if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
		--             vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
		--         elseif cmp.visible() then
		--             cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
		--         else
		--             fallback()
		--         end
		--     end,
		--     s = function(fallback)
		--         if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
		--             vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
		--         else
		--             fallback()
		--         end
		--     end
		-- }),
		-- ["<S-Tab>"] = cmp.mapping({
		--     i = function(fallback)
		--         if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
		--             return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), 'm', true)
		--         elseif cmp.visible() then
		--             cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
		--         else
		--             fallback()
		--         end
		--     end,
		--     s = function(fallback)
		--         if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
		--             return vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_backward)"), 'm', true)
		--         else
		--             fallback()
		--         end
		--     end
		-- }),
		["<Down>"] = cmp.mapping(
			cmp.mapping.select_next_item({
				behavior = cmp.SelectBehavior.Select,
			}),
			{ "i" }
		),
		["<Up>"] = cmp.mapping(
			cmp.mapping.select_prev_item({
				behavior = cmp.SelectBehavior.Select,
			}),
			{ "i" }
		),
		["<C-n>"] = cmp.mapping({
			i = function(fallback)
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				else
					fallback()
				end
			end,
		}),
		["<C-p>"] = cmp.mapping({
			i = function(fallback)
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
				else
					fallback()
				end
			end,
		}),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.close(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping({
			i = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),
		}),
	},

	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "ultisnips" }, -- For ultisnips users.
		{ name = "codeium", keyword_length = 2 },
		{ name = "path" },
		{ name = "orgmode" },
		{ name = "vim-dadbod-completion" },
	}, { { name = "buffer", keyword_length = 5 } }),
})

local cmdline_mapping = {
	-- ['<Tab>'] = {
	--     c = function()
	--         if cmp.visible() then
	--             cmp.select_next_item()
	--         else
	--             feedkeys.call(keymap.t('<C-z>'), 'n')
	--         end
	--     end,
	-- },
	-- ['<S-Tab>'] = {
	--     c = function()
	--         if cmp.visible() then
	--             cmp.select_prev_item()
	--         else
	--             feedkeys.call(keymap.t('<C-z>'), 'n')
	--         end
	--     end,
	-- },
	["<C-n>"] = {
		c = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end,
	},
	["<C-p>"] = {
		c = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end,
	},
	["<C-e>"] = { c = cmp.mapping.close() },

	["<CR>"] = cmp.mapping({
		c = function(fallback)
			if cmp.get_selected_entry() == nil then
				cmp.mapping.close()
				fallback()
			elseif cmp.visible() then
				cmp.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				})
			else
				fallback()
			end
		end,
	}),
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmdline_mapping,
	sources = { { name = "buffer", keyword_length = 5 } },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmdline_mapping,
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", keyword_length = 3 } }),
})

vim.cmd([[
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })

    " Source is automatically added, you just need to include it in the chain complete list
    let g:completion_chain_complete_list = {
        \   'sql': [
        \    {'complete_items': ['vim-dadbod-completion']},
        \   ],
        \ }
    " Make sure `substring` is part of this list. Other items are optional for this completion source
    let g:completion_matching_strategy_list = ['exact', 'substring']
    " Useful if there's a lot of camel case items
    let g:completion_matching_ignore_case = 1

    let g:vim_dadbod_completion_mark = '󰆼'
]])
