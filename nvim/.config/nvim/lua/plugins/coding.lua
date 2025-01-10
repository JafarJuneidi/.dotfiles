return {
    {
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        version = '*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'enter',
                ['<C-y>'] = { 'select_and_accept' },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = false,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono',
            },

            completion = {
                accept = {
                    -- experimental auto-brackets support
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    draw = {
                        treesitter = { 'lsp' },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                },
                ghost_text = {
                    enabled = true,
                },
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
                cmdline = {},
                providers = {
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                },
            },
        },
        opts_extend = { 'sources.default' },
    },

    -- auto pairs
    {
        'echasnovski/mini.pairs',
        version = '*',
        event = 'VeryLazy',
        opts = {},
    },

    -- Better text-objects
    {
        'echasnovski/mini.ai',
        version = '*',
        event = 'VeryLazy',
        opts = {},
    },

    -- comments
    {
        'folke/ts-comments.nvim',
        event = 'VeryLazy',
        opts = {},
    },

    {
        'folke/lazydev.nvim',
        ft = 'lua',
        cmd = 'LazyDev',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                -- { path = "LazyVim", words = { "LazyVim" } },
                { path = 'snacks.nvim', words = { 'Snacks' } },
                { path = 'lazy.nvim', words = { 'LazyVim' } },
            },
        },
    },
}
