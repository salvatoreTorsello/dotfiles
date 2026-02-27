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
                        )

                        -- LspAttach is where you enable features that only work
                        -- if there is a language server active in the file
                        vim.api.nvim_create_autocmd('LspAttach', {
                                desc = 'LSP actions',
                                callback = function(event)
                                        local opts = {buffer = event.buf}

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
                                        -- "jinja-lsp",
                                },
                                handlers = {
                                        function(server_name)
                                                -- require('lspconfig')[server_name].setup({})
                                                vim.lsp.config(server_name,{})
                                        end,
                                }
                        })

                        -- Python LSP (pylsp) with automatic venv detection
                        -- local lspconfig = require('lspconfig')
                        local util = require("lspconfig/util")

                        -- lspconfig.pylsp.setup {
                        vim.lsp.config('pylsp', {
                                on_attach = on_attach,
                                capabilities = capabilities,
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
                                                                ignore = {},   -- keep empty unless you need to skip rules
                                                        }
                                                }
                                        }
                                }
                        })

                        -- Autoformat on save
                        vim.api.nvim_create_autocmd("BufWritePre", {
                                pattern = { "*.py", "*.c", "*.cpp", "*.h", "*.hpp", "*.cc", "*.hh", "*.cxx", "*.hxx" },
                                callback = function(args)
                                        local ft = vim.bo[args.buf].filetype
                                        if ft == "python" then
                                                -- Synchronously format the buffer with Black
                                                local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
                                                local formatted = vim.fn.systemlist("black -l 80 -q -", lines)
                                                if vim.v.shell_error == 0 then
                                                        vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, formatted)
                                                end
                                        else
                                                -- fallback to lsp formatter (clangd) for c/c++
                                                vim.lsp.buf.format({ async = false })
                                        end
                                end,
                        })

                        -- ------------------------------------------------------------------
                        -- Recursively format every .c / .h file in the current directory
                        -- ------------------------------------------------------------------
                        vim.api.nvim_create_user_command('ClangFormatAll', function()
                                local scan = require 'plenary.scandir'

                                -- 1. Collect every .c / .h file under "."
                                local paths = scan.scan_dir('.', {
                                        search_pattern = [[^.*%.[ch]$]],
                                        respect_gitignore = false,
                                })

                                if #paths == 0 then
                                        vim.notify('No .c / .h files found', vim.log.levels.WARN)
                                        return
                                end

                                -- 2. Load each file into a hidden buffer and format via LSP
                                local done = 0
                                for _, path in ipairs(paths) do
                                        vim.schedule(function()
                                                vim.cmd('silent noautocmd edit ' .. vim.fn.fnameescape(path))
                                                vim.lsp.buf.format({ async = false })
                                                vim.cmd('silent noautocmd write')
                                                vim.cmd('silent noautocmd bdelete')

                                                done = done + 1
                                                if done == #paths then
                                                        vim.notify('clang-format (via LSP) finished', vim.log.levels.INFO)
                                                end
                                        end)
                                end
                        end, { desc = 'LSP-format every .c / .h file in cwd (recursive)' })

                end
        }
}
