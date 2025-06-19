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
if JSTS_FORMATTER_ENV ~= vim.NIL then
	formatters_by_ft.typescript = { JSTS_FORMATTER_ENV }
	formatters_by_ft.typescriptreact = { JSTS_FORMATTER_ENV }
	formatters_by_ft.javascript = { JSTS_FORMATTER_ENV }
	formatters_by_ft.javascriptreact = { JSTS_FORMATTER_ENV }
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
