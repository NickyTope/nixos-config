return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	lazy = true,
	ft = { "typescript", "typescriptreact" },
	opts = {
		settings = {
			jsx_close_tag = {
				enable = true,
			},
		},
	},
}
