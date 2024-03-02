return {
	"folke/which-key.nvim",
	opts = {},
	config = function()
		-- document existing key chains
		require("which-key").register(require("user.keymaps").map_which_key_normal)
		-- register which-key VISUAL mode
		-- required for visual <leader>hs (hunk stage) to work
		require("which-key").register(require("user.keymaps").map_which_key_visual, { mode = "v" })
	end,
}
