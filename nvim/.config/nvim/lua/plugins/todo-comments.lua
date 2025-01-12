return {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    opts = {},
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
            -- Trouble
            { "<leader>to", "<CMD>TodoTrouble<CR>", desc = "t[o]do" },
            -- Search
            { "<leader>st", "<CMD>TodoFzfLua<CR>", desc = "[t]odo" },
        },
}
