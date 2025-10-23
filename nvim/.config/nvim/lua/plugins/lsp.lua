return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
        'ibhagwan/fzf-lua',
    },
    opts = function()
        ---@class PluginLspOpts
        local ret = {
            -- options for vim.diagnostic.config()
            ---@type vim.diagnostic.Opts
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = 'if_many',
                    prefix = '●',
                },
                severity_sort = true,
                float = {
                    focusable = false,
                    style = 'minimal',
                    border = 'rounded',
                    source = 'if_many',
                    header = '',
                    prefix = '',
                },
            },
            -- LSP Server Settings
            servers = {
                lua_ls = {
                    -- mason = false, -- set to false if you don't want this server to be installed with mason
                    -- Use this to add any additional keymaps
                    -- for specific lsp servers
                    -- ---@type LazyKeysSpec[]
                    -- keys = {},
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = 'Replace',
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                            doc = {
                                privateName = { '^_' },
                            },
                            hint = {
                                enable = true,
                                setType = false,
                                paramType = true,
                                paramName = 'Disable',
                                semicolon = 'Disable',
                                arrayIndex = 'Disable',
                            },
                        },
                    },
                },
                pyright = {
                    settings = {
                        pyright = {
                            -- Using Ruff's import organizer
                            disableOrganizeImports = true,
                        },
                        python = {
                            analysis = {
                                -- Ignore all files for analysis to exclusively use Ruff for linting
                                ignore = { '*' },
                            },
                        },
                    },
                },
                ruff = {
                    capabilities = {
                        hoverProvider = false,
                    },
                },
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        }
        return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local buffer = args.buf

                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = buffer, desc = 'LSP: ' .. desc })
                end

                local fzf = require 'fzf-lua'
                map('gd', function()
                    fzf.lsp_definitions { jump1 = true }
                end, '[d]efinition')
                map('gr', function()
                    fzf.lsp_references { jump1 = true }
                end, '[r]eferences')
                map('gI', function()
                    fzf.lsp_implementations { jump1 = true }
                end, '[I]mplementation')
                map('gy', function()
                    fzf.lsp_typedefs { jump1 = true }
                end, 't[y]pe definition')
                map('gD', fzf.lsp_declarations, '[D]eclaration')
                map('<leader>ca', fzf.lsp_code_actions, '[c]ode [a]ction', { 'n', 'x' })

                map('gK', vim.lsp.buf.signature_help, 'signature help')
                map('<c-k>', vim.lsp.buf.signature_help, 'signature help', { 'i' })
                map('<leader>cr', vim.lsp.buf.rename, '[r]ename')

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup('lsp_highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = buffer,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = buffer,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd('LspDetach', {
                        group = vim.api.nvim_create_augroup('lsp_detach', { clear = true }),
                        callback = function(args2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = 'lsp_highlight', buffer = args2.buf }
                        end,
                    })
                end
            end,
        })

        vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

        local servers = opts.servers
        local has_blink, blink = pcall(require, 'blink.cmp')
        -- stylua: ignore
        local capabilities = vim.tbl_deep_extend(
            'force',
            {},
            vim.lsp.protocol.make_client_capabilities(),
            has_blink and blink.get_lsp_capabilities() or {}
        )

        local function setup(server)
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            local server_opts = vim.tbl_deep_extend('force', {
                capabilities = vim.deepcopy(capabilities),
            }, servers[server] or {})
            if server_opts.enabled == false then
                return
            end

            if opts.setup[server] then
                if opts.setup[server](server, server_opts) then
                    return
                end
            elseif opts.setup['*'] then
                if opts.setup['*'](server, server_opts) then
                    return
                end
            end
            require('lspconfig')[server].setup(server_opts)
        end

        ---@type string[]
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'stylua',
        })

        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        require('mason-lspconfig').setup {
            ensure_installed = {},
            automatic_installation = false,
            handlers = { setup },
        }
    end,
}
