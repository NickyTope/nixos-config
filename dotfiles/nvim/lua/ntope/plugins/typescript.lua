-- return {
-- 	"pmizio/typescript-tools.nvim",
-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
-- 	lazy = true,
-- 	ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
-- 	opts = {
-- 		settings = {
-- 			jsx_close_tag = {
-- 				enable = true,
-- 			},
-- 		},
-- 	},
-- }

return {
	"yioneko/nvim-vtsls",
	config = function()
		require("vtsls").config({
			settings = {
				typescript = {
					inlayHints = {
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						enumMemberValues = { enabled = true },
					},
				},
			},
		})
	end,
}
