return {
    -- the colorscheme should be available when starting Neovim
    {
        'ellisonleao/gruvbox.nvim',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        opts = {
            terminal_colors = true, -- add neovim terminal colors
            undercurl = true,
            underline = false,
            bold = true,
            italic = {
                strings = false,
                emphasis = false,
                comments = false,
                operators = false,
                folds = false,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = true, -- invert background for search, diffs, statuslines and errors
            contrast = '', -- can be "hard", "soft" or empty string
            palette_overrides = {},
            overrides = {},
            dim_inactive = false,
            transparent_mode = false,
        },
        init = function()
            -- vim.cmd.colorscheme 'gruvbox'
        end,
    },

    {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            --     vim.cmd.colorscheme 'rose-pine-moon'
        end,
    },

    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        -- init = function()
        --     vim.cmd.colorscheme 'kanagawa'
        -- end,
    },

    {
        'catppuccin/nvim',
        name = 'catppuccin',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        opts = {},
        init = function()
            vim.cmd.colorscheme 'catppuccin-macchiato'
        end,
    },

    {
        'folke/tokyonight.nvim',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        opts = {},
        -- init = function()
        --     vim.cmd.colorscheme 'tokyonight-storm'
        -- end,
    },

    {
        'rose-pine/neovim',
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        opts = {},
        config = function()
            --     vim.cmd.colorscheme 'rose-pine-moon'
        end,
    },
}
