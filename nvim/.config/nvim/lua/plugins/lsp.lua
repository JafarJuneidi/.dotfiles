return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			"nvimtools/none-ls.nvim",

			"folke/neodev.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds -- Has to load keymaps before pluginslsp

			require("neodev").setup()

			-- mason-lspconfig requires that these setup functions are called in this order
			-- before setting up the servers.
			require("mason").setup()
			require("mason-lspconfig").setup()

			local servers = {
				clangd = {},
				-- gopls = {},
				-- rust_analyzer = {},
				pyright = {},
				tsserver = {
					experimental = {
						enableProjectDiagnostics = true,
					},
				},
				html = { filetypes = { "html", "twig", "hbs" } },

				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						-- NOTE: toggle below to ignore Lua_LS"s noisy `missing-fields` warnings
						-- diagnostics = { disable = { "missing-fields" } },
					},
				},
				beancount = {
					init_options = {
						journal_file = "~/personal/bean/main.beancount",
					},
				},
			}

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- Ensure the servers above are installed
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			local on_attach = function(_, buffer_number)
				-- Pass the current buffer to map lsp keybinds
				map_lsp_keybinds(buffer_number)

				-- Create a command `:Format` local to the LSP buffer
				vim.api.nvim_buf_create_user_command(buffer_number, "Format", function(_)
					vim.lsp.buf.format({
						filter = function(format_client)
							-- Use Prettier to format TS/JS if it's available
							return format_client.name ~= "tsserver" or not null_ls.is_registered("prettier")
						end,
					})
				end, { desc = "LSP: Format current buffer" })
			end

			mason_lspconfig.setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = servers[server_name],
						filetypes = (servers[server_name] or {}).filetypes,
						init_options = (servers[server_name] or {}).init_options,
					})
				end,
			})

			-- Congifure LSP linting, formatting, diagnostics, and code actions
			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics
			local code_actions = null_ls.builtins.code_actions

			null_ls.setup({
				sources = {
					-- formatting
					formatting.prettierd,
					formatting.stylua,
					formatting.black,

					-- diagnostics
					-- diagnostics.eslint_d.with({
					-- 	condition = function(utils)
					-- 		return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
					-- 	end,
					-- }),

					-- code actions
					-- code_actions.eslint_d.with({
					-- 	condition = function(utils)
					-- 		return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
					-- 	end,
					-- }),
				},
			})
		end,
	},
}
