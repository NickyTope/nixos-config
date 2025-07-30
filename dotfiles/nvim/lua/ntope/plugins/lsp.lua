return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"nvim-lua/lsp-status.nvim",
	},

	config = function()
		local icons = require("ntope.icons")

		local lsp_status = require("lsp-status")
		lsp_status.config({
			indicator_errors = icons.error,
			indicator_warnings = icons.warning,
			indicator_info = icons.info,
			indicator_hint = icons.hint,
			indicator_ok = icons.ok,
		})
		lsp_status.register_progress()

		local my_attach = function(client)
			lsp_status.on_attach(client)
		end

		local lsp = require("lspconfig")

		require("lspconfig.configs").vtsls = require("vtsls").lspconfig
		require("lspconfig").vtsls.setup({
			on_attach = my_attach,
		})

		lsp.nixd.setup({
			on_attach = function(client, bufnr)
				my_attach(client)
			end,
			cmd = { "nixd" },
			settings = {
				nixd = {
					nixpkgs = {
						expr = "import <nixpkgs> { }",
					},
					formatting = {
						command = { "alejandra" }, -- or nixfmt or nixpkgs-fmt
					},
				},
			},
		})

		-- installed from bun global
		lsp.eslint.setup({
			on_attach = function(client, bufnr)
				my_attach(client)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					-- command = "EslintFixAll",
					callback = function()
						local formatter = vim.fn.getenv("JSTS_FORMATTER")
						if formatter == vim.NIL or formatter == "prettierd" then
							vim.cmd("EslintFixAll")
						end
					end,
				})
			end,
		})

		vim.lsp.enable("biome")

		-- no nix package for this yet
		lsp.groovyls.setup({
			cmd = { "docker", "run", "--rm", "-ia", "stdin", "-ia", "stderr", "-ia", "stdout", "glsp" },
		})

		-- installed from bun global
		lsp.emmet_ls.setup({
			on_attach = my_attach,
			filetypes = {
				"css",
				"eruby",
				"html",
				"javascript",
				"javascriptreact",
				"less",
				"sass",
				"scss",
				"svelte",
				"pug",
				"typescriptreact",
				"vue",
			},
			init_options = {
				html = {
					options = {
						-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
						["bem.enabled"] = true,
					},
				},
			},
		})

		-- installed from bun global
		lsp.cssmodules_ls.setup({
			-- provide your on_attach to bind keymappings
			on_attach = my_attach,
			-- optionally
			init_options = {
				camelCase = "dashes",
			},
		})

		-- installed from nixpkgs
		lsp.lua_ls.setup({
			on_attach = my_attach,
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
					return
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							-- Depending on the usage, you might want to add additional paths here.
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						},
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					},
				})
			end,
			settings = {
				Lua = {},
			},
		})

		-- installed from bun global
		lsp.dockerls.setup({ on_attach = my_attach })
		-- installed from bun global
		lsp.vimls.setup({ on_attach = my_attach })
		-- installed from bun global
		lsp.stylelint_lsp.setup({
			filetypes = { "css", "scss" },
			settings = {
				stylelintplus = {
					autoFixOnFormat = true,
				},
			},
		})

		-- installed from bun global
		lsp.tailwindcss.setup({
			filetypes = {
				-- "aspnetcorerazor",
				-- "astro",
				-- "astro-markdown",
				-- "blade",
				-- "clojure",
				-- "django-html",
				-- "htmldjango",
				-- "edge",
				-- "eelixir",
				-- "elixir",
				-- "ejs",
				-- "erb",
				-- "eruby",
				-- "gohtml",
				-- "haml",
				-- "handlebars",
				-- "hbs",
				-- "html",
				-- "html-eex",
				-- "heex",
				-- "jade",
				-- "leaf",
				-- "liquid",
				-- "markdown",
				-- "mdx",
				-- "mustache",
				-- "njk",
				-- "nunjucks",
				-- "php",
				-- "razor",
				-- "slim",
				-- "twig",
				-- "css",
				-- "less",
				-- "postcss",
				-- "sass",
				-- "scss",
				-- "stylus",
				-- "sugarss",
				-- "javascript",
				-- "javascriptreact",
				-- "reason",
				-- "rescript",
				-- "typescript",
				"typescriptreact",
				-- "vue",
				-- "svelte",
			},
		})

		-- installed from bun global
		lsp.jsonls.setup({
			on_attach = my_attach,
			cmd = { "vscode-json-language-server", "--stdio" },
		})

		-- installed from bun global
		lsp.yamlls.setup({
			on_attach = my_attach,
			filetypes = { "yaml" },
			autostart = false,
			settings = {
				redhat = { telemetry = { enabled = false } },
				yaml = {
					keyOrdering = false,
				},
			},
		})

		-- installed from nixpkgs
		lsp.gopls.setup({
			on_attach = function(client)
				my_attach(client)
			end,
		})

		-- installed from nixpkgs
		lsp.pylsp.setup({
			on_attach = function(client)
				my_attach(client)
			end,
		})

		-- installed from nixpkgs
		lsp.lemminx.setup({
			cmd = { "/home/nicky/apps/lemminx/lemminx-linux" },
		})

		local config = vim.diagnostic.config()
		config.underline = true
		config.virtual_lines = { current_line = true }
		vim.diagnostic.config(config)
	end,
}
