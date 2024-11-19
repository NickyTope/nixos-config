return {
	{
		"jackMort/ChatGPT.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("chatgpt").setup({
				openai_params = {
					model = "gpt-4o",
					max_tokens = 4095,
				},
			})
		end,
	},
}
