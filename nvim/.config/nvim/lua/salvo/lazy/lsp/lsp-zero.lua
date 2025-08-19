return {
        {
                'williamboman/mason.nvim',
                lazy = false,
                opts = {},
        },

        -- Autocompletion
        {
                'hrsh7th/nvim-cmp',
                event = 'InsertEnter',
                config = function()
                        local cmp = require('cmp')

                        cmp.setup({
                                sources = {
                                        {name = 'nvim_lsp'},
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
                cmd = {'LspInfo', 'LspInstall', 'LspStart'},
                event = {'BufReadPre', 'BufNewFile'},
                dependencies = {
                        {'hrsh7th/cmp-nvim-lsp'},
                        {'williamboman/mason.nvim'},
                        {'williamboman/mason-lspconfig.nvim'},
                },
                init = function()
                        -- Reserve a space in the gutter
                        -- This will avoid an annoying layout shift in the screen
                        vim.opt.signcolumn = 'yes'
                        -- Set the wait time before the diagnostic window appears
                        vim.opt.updatetime = 150

                        -- Configure diagnostics to appear in floating windows
                        vim.diagnostic.config({
                                float = {
                                        border = "rounded",
                                        source = "always",
                                        header = "",
                                        prefix = "",
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

                        -- Add cmp_nvim_lsp capabilities settings to lspconfig
                        -- This should be executed before you configure any language server
                        lsp_defaults.capabilities = vim.tbl_deep_extend(
                                'force',
                                lsp_defaults.capabilities,
                                require('cmp_nvim_lsp').default_capabilities()
                                        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                                        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                                        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                                        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                                        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                                        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                                        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                                        vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)

                                        -- Automatically show diagnostics when the cursor stops on a line
                                        vim.api.nvim_create_autocmd("CursorHold", {
                                                buffer = event.buf,
                                                callback = function()
                                                        vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})
                                                end,
                                        })
                                end,
                        })

                        require('mason-lspconfig').setup({
                                ensure_installed = {
                                        "lua_ls",
                                        "pylsp",
                                        "clangd",
                                        "jinja-lsp",
                                },
                                handlers = {
                                        function(server_name)
                                                require('lspconfig')[server_name].setup({})
                                        end,
                                }
                        })

                        -- Python LSP (pylsp) with automatic venv detection
                        local lspconfig = require('lspconfig')
                        local util = require("lspconfig/util")

                        lspconfig.pylsp.setup {
                                on_attach = on_attach,
                                capabilities = capabilities,
                                root_dir = function(fname)
                                        return util.root_pattern("pyproject.toml", "setup.py", "requirements.txt", "venv")(fname) or
                                               util.path.dirname(fname)
                                end,
                                settings = {
                                        pylsp = {
                                                plugins = {
                                                        jedi = {environment = (function()
                                                                local venv_path = vim.fn.getcwd() .. "/venv/bin/python"
                                                                if vim.fn.filereadable(venv_path) == 1 then
                                                                        return venv_path
                                                                end
                                                                return vim.fn.exepath("python") -- fallback to system Python
                                                        end)()
                                                        },
                                                        -- Enable Black formatter
                                                        black = {
                                                                enabled = true,
                                                                path = "/usr/bin/black",
                                                        },
                                                        -- Ensure formatting is enabled
                                                        -- pylsp_mypy = {
                                                        --
                                                        --         enabled = true,
                                                        --         live_mode = false,
                                                        --
                                                        -- },
                                                        -- autopep8 = {
                                                        --         enabled = false,
                                                        -- },
                                                        -- yapf = {
                                                        --         enabled = false,
                                                        -- }
                                                }
                                        }
                                }
                        }

                        -- Autoformat on save
                        vim.api.nvim_create_autocmd("BufWritePre", {
                                pattern = "*.py",
                                callback = function()
                                        vim.cmd("!black %:p")                    -- Run Black in correct dir
                                end,
                        })
                end
        }
}
