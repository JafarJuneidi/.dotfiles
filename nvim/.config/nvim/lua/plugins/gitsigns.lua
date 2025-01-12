return {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
    opts = {
        signs = {
            add = { text = '▎' },
            change = { text = '▎' },
            delete = { text = '' },
            topdelete = { text = '' },
            changedelete = { text = '▎' },
            untracked = { text = '▎' },
        },
        -- NOTE: Haven't tested this, but most likely the staged signs differ in color from the normal signs above.
        signs_staged = {
            add = { text = '▎' },
            change = { text = '▎' },
            delete = { text = '' },
            topdelete = { text = '' },
            changedelete = { text = '▎' },
        },
        on_attach = function(buffer)
            local gitsigns = package.loaded.gitsigns

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            map('n', ']h', function()
                if vim.wo.diff then
                    vim.cmd.normal { ']c', bang = true }
                else
                    gitsigns.nav_hunk 'next'
                end
            end, 'Next [h]unk')

            map('n', '[h', function()
                if vim.wo.diff then
                    vim.cmd.normal { '[c', bang = true }
                else
                    gitsigns.nav_hunk 'prev'
                end
            end, 'Prev [h]unk')

            map('n', ']H', function()
                gitsigns.nav_hunk 'last'
            end, 'Last [H]unk')

            map('n', '[H', function()
                gitsigns.nav_hunk 'first'
            end, 'First [H]unk')

            map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', '[s]tage Hunk')
            map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', '[r]eset Hunk')
            map('n', '<leader>hS', gitsigns.stage_buffer, '[S]tage Buffer')
            map('n', '<leader>hu', gitsigns.undo_stage_hunk, '[u]ndo Stage Hunk')
            map('n', '<leader>hR', gitsigns.reset_buffer, '[R]eset Buffer')
            map('n', '<leader>hp', gitsigns.preview_hunk, '[p]review Hunk')
            map('n', '<leader>hP', gitsigns.preview_hunk_inline, '[P]review Hunk Inline')
            map('n', '<leader>hb', function()
                gitsigns.blame_line { full = true }
            end, '[b]lame Line')
            map('n', '<leader>hB', function()
                gitsigns.blame()
            end, '[B]lame Buffer')
            map('n', '<leader>hd', gitsigns.diffthis, '[d]iff This')
            map('n', '<leader>hD', function()
                gitsigns.diffthis '~'
            end, '[D]iff This ~')

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')

            -- toggle
            map('n', '<leader>td', gitsigns.toggle_deleted, 'Git show [b]lame line')
            map('n', '<leader>tb', gitsigns.toggle_current_line_blame, 'git show [d]eleted')
        end,
    },
}
