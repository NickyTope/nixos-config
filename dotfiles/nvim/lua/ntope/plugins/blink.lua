return {
	{
		"saghen/blink.cmp",
		version = "v0.*",
		-- !Important! Make sure you're using the latest release of LuaSnip
		-- `main` does not work at the moment
		dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
		lazy = true,
		event = "InsertEnter",
		opts = {
			keymap = {
				-- preset = "enter",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<CR>"] = { "accept", "fallback" },

				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },

				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			snippets = {
				expand = function(snippet)
					require("luasnip").lsp_expand(snippet)
				end,
				active = function(filter)
					if filter and filter.direction then
						return require("luasnip").jumpable(filter.direction)
					end
					return require("luasnip").in_snippet()
				end,
				jump = function(direction)
					require("luasnip").jump(direction)
				end,
			},
			sources = {
				default = { "lsp", "path", "luasnip", "buffer" },
				cmdline = {},
			},
			completion = {
				documentation = {
					auto_show = true,
				},
			},
		},
	},
}
