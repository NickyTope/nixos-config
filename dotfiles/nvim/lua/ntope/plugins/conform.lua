local formatters_by_ft = {
	lua = { "stylua" },
	markdown = { "prettierd" },
	json = { "prettierd" },
	yaml = { "prettierd" },
	scss = { lsp_format = "prefer" },
	css = { lsp_format = "prefer" },
	nix = { lsp_format = "prefer" },
}

-- use .envrc
-- export JSTS_FORMATTER=prettier
-- direnv allow .
local JSTS_FORMATTER_ENV = vim.fn.getenv("JSTS_FORMATTER")
if JSTS_FORMATTER_ENV == "prettier" then
	formatters_by_ft.typescript = { "prettierd" }
	formatters_by_ft.typescriptreact = { "prettierd" }
	formatters_by_ft.javascript = { "prettierd" }
	formatters_by_ft.javascriptreact = { "prettierd" }
end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>lf",
			function()
				require("conform").format()
			end,
			mode = "",
			desc = "Conform: Format",
		},
	},
	opts = {
		formatters_by_ft = formatters_by_ft,
		format_on_save = true,
	},
}
