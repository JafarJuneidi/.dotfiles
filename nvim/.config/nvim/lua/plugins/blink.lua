return {
    -- add blink.compat
    {
        'saghen/blink.compat',
        -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
        version = '*',
        -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
        lazy = true,
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {},
    },
    {
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        version = '1.*',
        opts_extend = { 'sources.default' },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'enter',
                ['<C-y>'] = { 'select_and_accept' },
                ['<C-d>'] = { 'scroll_documentation_down' },
                ['<C-u>'] = { 'scroll_documentation_up' },
            },

            completion = {
                menu = {
                    draw = {
                        treesitter = { 'lsp' },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                },
            },

            cmdline = {
                enabled = false,
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev' },
                providers = {
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100, -- show at a higher priority than lsp
                    },
                },
            },
        },
    },
}
