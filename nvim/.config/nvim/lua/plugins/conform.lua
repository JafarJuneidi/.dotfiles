return {
    {
        'stevearc/conform.nvim',
        event = 'VeryLazy',
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                if not vim.g.format_on_save then
                    return
                end
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                local lsp_format_opt
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    lsp_format_opt = 'never'
                else
                    lsp_format_opt = 'fallback'
                end
                return {
                    timeout_ms = 1000,
                    lsp_format = lsp_format_opt,
                }
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
                -- Conform will run multiple formatters sequentially
                python = { 'ruff_format' },
                c = { 'clang-format' },
                cpp = { 'clang-format' },
                markdown = { 'prettier' },
                -- Conform will run the first available formatter
                javascript = { 'prettier', stop_after_first = true },
                javascriptreact = { 'prettier' },
            },
        },
        keys = {
            {
                '<leader>cf',
                function()
                    require('conform').format { async = true, lsp_format = 'fallback' }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        config = function(_, opts)
            -- enable format on save by default
            vim.g.format_on_save = true

            require('conform').setup(opts)
            vim.keymap.set('n', '<leader>tf', function(_)
                vim.g.format_on_save = not vim.g.format_on_save
            end, { desc = '[f]ormat on save' })
        end,
    },
}
