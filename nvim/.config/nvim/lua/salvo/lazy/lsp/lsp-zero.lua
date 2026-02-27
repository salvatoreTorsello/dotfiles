return {
        -- Mason for managing external tools
        {
                'williamboman/mason.nvim',
                lazy = false,
                opts = {},
        },

        -- Formatter integration
        {
                'stevearc/conform.nvim',
                event = { 'BufWritePre' },
                config = function()
                        require('conform').setup({
                                formatters_by_ft = {
                                        c = { 'clang-format' },
                                        cpp = { 'clang-format' },
                                        cuda = { 'clang-format' },
                                },
                                format_on_save = {
                                        timeout_ms = 1000,
                                        lsp_fallback = false,
                                },
                                log_level = vim.log.levels.DEBUG,
                        })

                        -- Keymap for manual formatting
                        vim.api.nvim_create_user_command('Format', function(args)
                                local range = nil
                                if args.count ~= -1 then
                                        local end_line = vim.api.nvim_buf_get_lines(0, args.count - 1, args.count, false)
                                        range = {
                                                { args.line1 - 1, 0 },
                                                { args.count - 1, #end_line[1] },
                                        }
                                end
                                require('conform').format({ async = true, lsp_fallback = false, range = range })
                        end, { range = true })
                end,
        },

        -- Autocompletion
        {
                'hrsh7th/nvim-cmp',
                event = 'InsertEnter',
                config = function()
                        local cmp = require('cmp')

                        cmp.setup({
                                sources = {
                                        { name = 'nvim_lsp' },
                                },
                                mapping = cmp.mapping.preset.insert({
                                        ['<C-Space>'] = cmp.mapping.complete(),
                                        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                                        ['<C-d>'] = cmp.mapping.scroll_docs(4),
                                }),
                                snippet = {
                                        expand = function(args)
                                                vim.snippet.expand(args.body)
                                        end,
                                },
                        })
                end
        },

        -- LSP
        {
                'neovim/nvim-lspconfig',
                cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
                event = { 'BufReadPre', 'BufNewFile' },
                dependencies = {
                        { 'hrsh7th/cmp-nvim-lsp' },
                        { 'williamboman/mason.nvim' },
                        { 'williamboman/mason-lspconfig.nvim' },
                },
                init = function()
                        vim.opt.signcolumn = 'yes'
                        vim.opt.updatetime = 150

                        vim.diagnostic.config({
                                float = {
                                        border = 'rounded',
                                        source = 'always',
                                        header = '',
                                        prefix = '',
                                },
                                virtual_text = false,
                                signs = true,
                                underline = true,
                                update_in_insert = false,
                                severity_sort = true,
                        })
                end,
                config = function()
                        local lsp_defaults = require('lspconfig').util.default_config

                        lsp_defaults.capabilities = vim.tbl_deep_extend(
                                'force',
                                lsp_defaults.capabilities,
                                require('cmp_nvim_lsp').default_capabilities()
                        )

                        -- Ensure clangd formatting is disabled to prevent conflicts
                        local on_attach = function(client, bufnr)
                                -- Disable formatting for clangd to let conform.nvim handle it
                                if client.name == 'clangd' then
                                        client.server_capabilities.documentFormattingProvider = false
                                        client.server_capabilities.documentRangeFormattingProvider = false
                                end

                                local opts = { buffer = bufnr }

                                vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                                vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                                vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                                vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                                vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                                vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                                vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                                vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                                -- Use conform.nvim for manual formatting instead of LSP
                                vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>Format<cr>', opts)
                                vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                                vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)

                                vim.api.nvim_create_autocmd("CursorHold", {
                                        buffer = bufnr,
                                        callback = function()
                                                vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
                                        end,
                                })
                        end

                        vim.api.nvim_create_autocmd('LspAttach', {
                                desc = 'LSP actions',
                                callback = function(event)
                                        on_attach(vim.lsp.get_client_by_id(event.data.client_id), event.buf)
                                end,
                        })

                        require('mason-lspconfig').setup({
                                ensure_installed = {
                                        "lua_ls",
                                        "pylsp",
                                        "clangd",
                                },
                                handlers = {
                                        function(server_name)
                                                require('lspconfig')[server_name].setup({
                                                        on_attach = on_attach,
                                                })
                                        end,
                                }
                        })

                        -- Configure pylsp
                        require('lspconfig').pylsp.setup({
                                on_attach = on_attach,
                                settings = {
                                        pylsp = {
                                                plugins = {
                                                        jedi = { environment = (function()
                                                                local venv_path = vim.fn.getcwd() .. "/venv/bin/python"
                                                                if vim.fn.filereadable(venv_path) == 1 then
                                                                        return venv_path
                                                                end
                                                                return vim.fn.exepath("python")
                                                        end)()
                                                        },
                                                        black = {
                                                                enabled = true,
                                                                path = "/usr/bin/black",
                                                        },
                                                        pycodestyle = {
                                                                enabled = false,
                                                                maxLineLength = 90,
                                                        },
                                                        ruff = {
                                                                enabled = true,
                                                                maxLineLength = 90,
                                                                select = { "E", "W", "F", "N" },
                                                        },
                                                        flake8 = {
                                                                enabled = false,
                                                                maxLineLength = 90,
                                                                ignore = {},
                                                        }
                                                }
                                        }
                                }
                        })
                end
        },
}

