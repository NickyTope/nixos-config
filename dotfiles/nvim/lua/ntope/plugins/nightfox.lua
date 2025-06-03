return {
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local nightfox = require("nightfox")
			nightfox.setup({
				options = {
					transparent = true,
					styles = {
						-- comments = "italic",
						keywords = "italic",
						-- functions = "NONE",
						conditionals = "bold",
						constants = "bold",
						numbers = "bold",
						-- operators = "italic",
						-- strings = "NONE",
						types = "bold",
						variables = "bold",
					},
					inverse = {
						match_paren = true,
					},
				},
			})
			vim.cmd([[colorscheme nightfox]])

			-- transparency
			vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])

			-- window separator
			vim.cmd([[hi Winseparator guifg=#9d79d6]])
		end,
	},
}
