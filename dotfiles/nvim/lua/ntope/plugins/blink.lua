return {
	{
		"saghen/blink.compat",
		-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
		version = "*",
		-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
		lazy = true,
		-- make sure to set opts so that lazy.nvim calls blink.compat's setup
		opts = {},
	},
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			{
				"supermaven-inc/supermaven-nvim",
				opts = {
					disable_inline_completion = true,
					disable_keymaps = true,
				},
			},
			{
				"huijiro/blink-cmp-supermaven",
			},
		},

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
			sources = {
				default = { "supermaven", "lsp", "path", "buffer" },
				per_filetype = {
					oil = {},
				},
				providers = {
					supermaven = {
						name = "supermaven",
						module = "blink-cmp-supermaven",
						async = true,
					},
				},
			},
			cmdline = {
				enabled = false,
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
