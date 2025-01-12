return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts_extend = { 'spec' },
    opts = {
        defaults = {},
        spec = {
            {
                mode = { 'n', 'v' },
                { '<leader>c', group = '[c]ode', mode = { 'n', 'x' } },
                { '<leader>s', group = '[s]earch' },
                { '<leader>g', group = '[g]it' },
                { '<leader>h', group = 'Git [h]unk' },
                { '<leader>t', group = '[t]oggle' },
                { '<leader>b', group = '[b]uffer' },
                { '<leader>u', group = '[u]i' },
                { '<leader>x', group = 'diagnostics/quickfi[x' },
                { 'g', group = '[g]oto' },
                { '[', group = 'prev' },
                { ']', group = 'next' },
                { 'gs', group = 'surround' },
                { 'z', group = 'fold' },
                {
                    '<leader>w',
                    group = '[w]indows',
                    proxy = '<c-w>',
                    expand = function()
                        return require('which-key.extras').expand.win()
                    end,
                },
            },
        },
    },
    keys = {
        {
            '<leader>?',
            function()
                require('which-key').show { global = false }
            end,
            desc = 'Buffer Keymaps (which-key)',
        },
        {
            '<c-w><space>',
            function()
                require('which-key').show { keys = '<c-w>', loop = true }
            end,
            desc = 'Window Hydra Mode (which-key)',
        },
    },
}
