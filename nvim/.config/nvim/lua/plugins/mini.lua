return {
    'echasnovski/mini.nvim',
    config = function()
        -- Better Around/Inside textobjects
        require('mini.ai').setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        require('mini.surround').setup()

        -- icons
        require('mini.icons').setup()

        -- notify
        require('mini.notify').setup()

        -- autopairs
        require('mini.pairs').setup()

        -- Simple and easy statusline.
        local statusline = require 'mini.statusline'
        statusline.setup { use_icons = vim.g.have_nerd_font }
        ---@diagnostic disable-next-line: duplicate-set-field
        statusline.section_location = function()
            return '%2l:%-2v'
        end
    end,
}
