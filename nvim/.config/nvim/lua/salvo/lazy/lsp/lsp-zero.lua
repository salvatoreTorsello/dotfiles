return {
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
                                        cs = { 'clang-format' },
                                },
                                format_on_save = {
                                        timeout_ms = 1000,
                                        lsp_fallback = true,
                                },
                        })

                        -- Refresh treesitter highlighting after formatting
                        vim.api.nvim_create_autocmd("BufWritePost", {
                                callback = function()
                                        -- Refresh treesitter highlighting
                                        vim.api.nvim_exec("TSBufEnable highlight", false)
                                end,
                        })

                        -- Keymap for manual formatting
                        vim.api.nvim_create_user_command('Format', function(args)
                                local range = nil
                                if args.count then
                                        local end_line = vim.api.nvim_buf_get_lines(0, args.count, args.count, false)
                                        range = {
                                                { args.line1 - 1, 0 },
                                                { args.count - 1, #end_line[1] },
                                        }
                                end
                                require('conform').format({ async = true, lsp_fallback = true, range = range })
                        end, { range = '%' })
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

                        vim.api.nvim_create_autocmd('LspAttach', {
                                desc = 'LSP actions',
                                callback = function(event)
                                        local opts = { buffer = event.buf }

                                        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                                        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                                        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                                        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                                        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                                        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                                        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                                        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                                        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                                        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                                        vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)

                                        vim.api.nvim_create_autocmd("CursorHold", {
                                                buffer = event.buf,
                                                callback = function()
                                                        vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
                                                end,
                                        })
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
                                                vim.lsp.config(server_name, {})
                                        end,
                                }
                        })

                        vim.lsp.config('pylsp', {
                                on_attach = on_attach,
                                capabilities = capabilities,
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

