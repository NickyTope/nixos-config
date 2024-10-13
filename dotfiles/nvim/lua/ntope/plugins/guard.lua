return {
	"nvimdev/guard.nvim",
	dependencies = {
		"nvimdev/guard-collection",
	},
	config = function()
		local ft = require("guard.filetype")

		ft("lua"):fmt("stylua")
		ft("markdown"):fmt("prettier")
		ft("json"):fmt("prettier")
		ft("yaml"):fmt("prettier")
		ft("scss"):fmt("lsp")
		ft("css"):fmt("lsp")

		vim.g.guard_config = {
			-- format on write to buffer
			fmt_on_save = true,
			-- use lsp if no formatter was defined for this filetype
			lsp_as_default_formatter = false,
			-- whether or not to save the buffer after formatting
			save_on_fmt = true,
		}
	end,
}
