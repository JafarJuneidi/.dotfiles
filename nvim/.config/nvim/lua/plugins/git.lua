return {
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",
	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				-- See `:help gitsigns.txt`
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local map_git_keybinds = require("user.keymaps").map_git_keybinds
					map_git_keybinds(bufnr, gs)
				end,
			})
		end,
	},
}
