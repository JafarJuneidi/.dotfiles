return {
    'mfussenegger/nvim-lint',
    events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
    opts = {
        -- Event to trigger linters
        events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
        linters_by_ft = {
            python = { 'ruff' },
        },
    },
    config = function(_, opts)
        local lint = require 'lint'
        lint.linters_by_ft = opts.linters_by_ft

        vim.api.nvim_create_autocmd(opts.events, {
            group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
