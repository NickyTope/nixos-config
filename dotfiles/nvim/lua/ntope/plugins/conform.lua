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
local JSTS_FORMATTER = vim.fn.getenv("JSTS_FORMATTER")
if JSTS_FORMATTER ~= vim.NIL then
	formatters_by_ft.typescript = { JSTS_FORMATTER }
	formatters_by_ft.typescriptreact = { JSTS_FORMATTER }
	formatters_by_ft.javascript = { JSTS_FORMATTER }
	formatters_by_ft.javascriptreact = { JSTS_FORMATTER }
	formatters_by_ft.json = { JSTS_FORMATTER }
end

local CSS_FORMATTER = vim.fn.getenv("CSS_FORMATTER")
if CSS_FORMATTER ~= vim.NIL then
	formatters_by_ft.css = { CSS_FORMATTER }
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
		formatters = {
			["biome-check"] = {
				command = "/etc/profiles/per-user/nicky/bin/biome",
			},
		},
		formatters_by_ft = formatters_by_ft,
		format_on_save = true,
	},
}
