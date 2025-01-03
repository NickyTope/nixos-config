return {
	"saghen/blink.cmp",
	version = "v0.*",
	-- !Important! Make sure you're using the latest release of LuaSnip
	-- `main` does not work at the moment
	dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
	lazy = true,
	event = "InsertEnter",
	opts = {
		keymap = {
			preset = "enter",
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
}
