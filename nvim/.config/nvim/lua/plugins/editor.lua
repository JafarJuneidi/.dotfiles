return {
    'tpope/vim-sleuth',

    -- section: which-key
    {
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
    },

    -- section: fzf-lua
    {
        'ibhagwan/fzf-lua',
        cmd = 'FzfLua',
        opts = function(_, _)
            local config = require 'fzf-lua.config'

            -- Quickfix
            config.defaults.keymap.fzf['ctrl-q'] = 'select-all+accept'
            config.defaults.keymap.fzf['ctrl-x'] = 'jump'
            config.defaults.keymap.builtin['<c-d>'] = 'preview-page-down'
            config.defaults.keymap.builtin['<c-u>'] = 'preview-page-up'

            return {
                fzf_colors = true,
                fzf_opts = {
                    ['--no-scrollbar'] = true,
                },
                defaults = {
                    formatter = 'path.dirname_first',
                },
                winopts = {
                    preview = {
                        scrollchars = { '┃', '' },
                    },
                },
                files = {
                    cwd_prompt = false,
                },
            }
        end,
        keys = function()
            local function open(command, opts)
                opts = opts or {}
                return require('fzf-lua')[command](opts)
            end

            local function fzflua(command, opts)
                opts = opts or {}
                return function()
                    open(command, vim.deepcopy(opts))
                end
            end

            local function fzflua_config_files()
                return fzflua('files', { cwd = vim.fn.stdpath 'config' })
            end

            -- Symbol filters
            ---@type table<string, string[]|boolean>?
            local kind_filter = {
                default = {
                    'Class',
                    'Constructor',
                    'Enum',
                    'Field',
                    'Function',
                    'Interface',
                    'Method',
                    'Module',
                    'Namespace',
                    'Package',
                    'Property',
                    'Struct',
                    'Trait',
                },
                markdown = false,
                help = false,
                -- you can specify a different filter for each filetype
                lua = {
                    'Class',
                    'Constructor',
                    'Enum',
                    'Field',
                    'Function',
                    'Interface',
                    'Method',
                    'Module',
                    'Namespace',
                    -- "Package", -- remove package since luals uses it for control flow structures
                    'Property',
                    'Struct',
                    'Trait',
                },
            }

            ---@param buf? number
            ---@return string[]?
            local function get_kind_filter(buf)
                buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
                local ft = vim.bo[buf].filetype
                if kind_filter == false then
                    return
                end
                if kind_filter[ft] == false then
                    return
                end
                if type(kind_filter[ft]) == 'table' then
                    return kind_filter[ft]
                end
                ---@diagnostic disable-next-line: return-type-mismatch
                return type(kind_filter) == 'table' and type(M.kind_filter.default) == 'table' and M.kind_filter.default or nil
            end

            local function symbols_filter(entry, ctx)
                if ctx.symbols_filter == nil then
                    ctx.symbols_filter = get_kind_filter(ctx.bufnr) or false
                end
                if ctx.symbols_filter == false then
                    return true
                end
                return vim.tbl_contains(ctx.symbols_filter, entry.kind)
            end

            return {
                -- git
                { '<leader>gc', '<CMD>FzfLua git_commits<CR>', desc = '[c]ommits' },
                { '<leader>gs', '<CMD>FzfLua git_status<CR>', desc = '[s]tatus' },

                -- ui
                { '<leader>uc', '<CMD>FzfLua colorschemes<CR>', desc = '[c]olorscheme with Preview' },

                -- buffer
                { '<leader>bl', '<CMD>FzfLua buffers sort_mru=true sort_lastused=true<CR>', desc = '[l]ist' },

                -- search
                { '<leader>sh', '<CMD>FzfLua help_tags<CR>', desc = '[h]elp Pages' },
                { '<leader>sk', '<CMD>FzfLua keymaps<CR>', desc = '[k]eymaps' },
                { '<leader>sf', '<CMD>FzfLua files<CR>', desc = '[f]iles' },
                { '<leader>sp', '<CMD>FzfLua builtin<CR>', desc = 'FzfLua [p]lugin' },
                { '<leader>sg', '<CMD>FzfLua live_grep<CR>', desc = '[g]rep' },
                { '<leader>sd', '<CMD>FzfLua diagnostics_document<CR>', desc = 'Document [d]iagnostics' },
                { '<leader>sD', '<CMD>FzfLua diagnostics_workspace<CR>', desc = 'Workspace [D]iagnostics' },
                { '<leader>sr', '<CMD>FzfLua resume<CR>', desc = '[r]esume' },
                { '<leader>so', '<CMD>FzfLua oldfiles<CR>', desc = '[o]ld files' },
                { '<leader>sb', '<CMD>FzfLua lgrep_curbuf<CR>', desc = 'Live grep in current [b]uffer' },
                -- { "<leader>sb", "<CMD>FzfLua grep_curbuf<CR>", desc = "Grep in current [B]uffer" },
                { '<leader>sn', fzflua_config_files(), desc = '[n]eovim files' },
                { '<leader>s"', '<CMD>FzfLua registers<CR>', desc = '["] Registers' },
                { '<leader>sa', '<CMD>FzfLua autocmds<CR>', desc = '[a]uto Commands' },
                { '<leader>sc', '<CMD>FzfLua commands<CR>', desc = '[r]ommands' },
                { '<leader>sm', '<CMD>FzfLua man_pages<CR>', desc = '[m]an Pages' },
                { '<leader>sq', '<CMD>FzfLua quickfix<CR>', desc = '[q]uickfix List' },
                { '<leader>sw', '<CMD>FzfLua grep_cword<CR>', desc = '[w]ord' },
                { '<leader>sw', '<CMD>FzfLua grep_visual<CR>', mode = 'v', desc = '[s]election' },
                {
                    '<leader>ss',
                    function()
                        require('fzf-lua').lsp_document_symbols {
                            regex_filter = symbols_filter,
                        }
                    end,
                    desc = 'Document [s]ymbols',
                },
                {
                    '<leader>sS',
                    function()
                        require('fzf-lua').lsp_live_workspace_symbols {
                            regex_filter = symbols_filter,
                        }
                    end,
                    desc = 'Workspace [S]ymbols',
                },
            }
        end,
    },

    -- Finds and lists all of the TODO, HACK, BUG, etc comment
    -- in your project and loads them into a browsable list.
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
        opts = {},
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
            -- Trouble
            { "<leader>to", "<CMD>TodoTrouble<CR>", desc = "t[o]do" },
            -- Search
            { "<leader>st", "<CMD>TodoFzfLua<CR>", desc = "[t]odo" },
        },
    },

    -- search/replace in multiple files
    {
        'MagicDuck/grug-far.nvim',
        opts = { headerMaxWidth = 80 },
        cmd = 'GrugFar',
    },

    -- better diagnostics list and others
    {
        'folke/trouble.nvim',
        cmd = { 'Trouble' },
        opts = {
            modes = {
                lsp = {
                    win = { position = 'right' },
                },
            },
        },
        keys = {
            { '<leader>tt', '<CMD>Trouble diagnostics toggle filter.buf=0  focus=true<CR>', desc = '[t]rouble' },
            { '<leader>tT', '<CMD>Trouble diagnostics toggle focus=true<CR>', desc = '[T]rouble' },
            {
                '[q',
                function()
                    if require('trouble').is_open() then
                        require('trouble').prev { skip_groups = true, jump = true }
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = 'Previous Trouble/Quickfix Item',
            },
            {
                ']q',
                function()
                    if require('trouble').is_open() then
                        require('trouble').next { skip_groups = true, jump = true }
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = 'Next Trouble/Quickfix Item',
            },
        },
    },
}
