return {
    -- section: gitsigns
    {
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
    },

    {
        'tpope/vim-fugitive',
        config = function()
            vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = '[s]tatus' })

            local fugitive_group = vim.api.nvim_create_augroup('fugitive', {})

            local autocmd = vim.api.nvim_create_autocmd
            autocmd('BufWinEnter', {
                group = fugitive_group,
                pattern = '*',
                callback = function()
                    if vim.bo.ft ~= 'fugitive' then
                        return
                    end

                    local bufnr = vim.api.nvim_get_current_buf()
                    local opts = { buffer = bufnr, remap = false }
                    vim.keymap.set('n', '<leader>p', function()
                        vim.cmd.Git 'push'
                    end, opts)

                    -- rebase always
                    vim.keymap.set('n', '<leader>P', function()
                        vim.cmd.Git { 'pull', '--rebase' }
                    end, opts)

                    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                    -- needed if i did not set the branch up correctly
                    vim.keymap.set('n', '<leader>t', ':Git push -u origin ', opts)
                end,
            })

            vim.keymap.set('n', 'gu', '<CMD>diffget //2<CR>')
            vim.keymap.set('n', 'gh', '<CMD>diffget //3<CR>')
        end,
    },

    {
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
    },
}
