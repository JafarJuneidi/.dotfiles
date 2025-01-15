return {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is way too old and doesn't work on Windows
    dependencies = { 'windwp/nvim-ts-autotag' },
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        additional_vim_regex_highlighting = true,
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
        auto_install = false,
        ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline', 'python', 'typescript', 'json' },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<C-space>',
                node_incremental = '<C-space>',
                scope_incremental = false,
                node_decremental = '<bs>',
            },
        },
    },
    config = function(_, opts)
        require('nvim-treesitter.configs').setup(opts)
    end,
}
