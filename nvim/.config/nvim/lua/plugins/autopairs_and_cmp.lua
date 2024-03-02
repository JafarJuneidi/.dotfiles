return {
	"hrsh7th/nvim-cmp",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
		"windwp/nvim-ts-autotag",
		"windwp/nvim-autopairs",
	},
	config = function()
		-- [[ Configure nvim-cmp ]]
		-- See `:help cmp`
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		require("nvim-autopairs").setup()

		-- Integrate nvim-autopairs with cmp
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		-- Load snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		-- luasnip.config.setup {}

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			-- window = {
			--     completion = cmp.config.window.bordered(),
			--     documentation = cmp.config.window.bordered(),
			-- },
			completion = {
				completeopt = "menu,menuone,noinsert",
			},
			mapping = cmp.mapping.preset.insert(require("user.keymaps").map_cmp_keybinds(cmp, luasnip)),
			sources = {
				{ name = "nvim_lsp" }, -- lsp
				{ name = "buffer", max_item_count = 5 }, -- text within current buffer
				{ name = "path", max_item_count = 3 }, -- file system paths
				{ name = "luasnip", max_item_count = 3 }, -- snippets
			},
			---@diagnostic disable-next-line: missing-fields
			formatting = {
				expandable_indicator = true,
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
			experimental = {
				ghost_text = true,
			},
		})
	end,
}
