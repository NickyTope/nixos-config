return {
	{
		"saghen/blink.cmp",
		version = "*",
		-- !Important! Make sure you're using the latest release of LuaSnip
		-- `main` does not work at the moment
		dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
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
				preset = "luasnip",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			cmdline = {
				sources = {},
			},
			completion = {
				documentation = {
					auto_show = true,
					window = { border = "single" },
				},
			},
		},
	},
}
