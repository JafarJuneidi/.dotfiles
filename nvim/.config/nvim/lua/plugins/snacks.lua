return {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {},
    config = function()
        local map = vim.keymap.set
        local function get_root()
            return Snacks.git.get_root()
        end

        -- git
        if vim.fn.executable 'lazygit' == 1 then
            map('n', '<leader>gg', function()
                ---@diagnostic disable-next-line: missing-fields
                Snacks.lazygit { cwd = get_root() }
                -- Snacks.lazygit()
            end, { desc = 'Lazy[g]it' })
            map('n', '<leader>gf', function()
                Snacks.lazygit.log_file()
            end, { desc = 'Lazygit Current [f]ile History' })
            map('n', '<leader>gl', function()
                ---@diagnostic disable-next-line: missing-fields
                Snacks.lazygit.log { cwd = get_root() }
                -- Snacks.lazygit.log()
            end, { desc = 'Lazygit [l]og' })
        end

        map({ 'n', 'x' }, '<leader>gB', function()
            Snacks.gitbrowse()
        end, { desc = '[B]rowse (open)' })
        map({ 'n', 'x' }, '<leader>gy', function()
            ---@diagnostic disable-next-line: missing-fields
            Snacks.gitbrowse {
                open = function(url)
                    vim.fn.setreg('+', url)
                end,
                notify = false,
            }
        end, { desc = 'Browse (cop[y])' })
    end,
}
