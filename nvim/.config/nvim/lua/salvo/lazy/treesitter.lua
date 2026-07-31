return {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",

        opts = {
                ensure_installed = {
                        "vimdoc", "javascript", "typescript", "c", "lua", "rust",
                        "jsdoc", "bash", "cpp"
                },
                sync_install = false,
                auto_install = true,
                indent = {
                        enable = true
                },
                highlight = {
                        enable = true,
                        additional_vim_regex_highlighting = { "markdown" },
                },
        },
        config = function(_, opts)

                require("nvim-treesitter.config").setup(opts)

                -- Custom parser config
                local treesitter_parser_config = require("nvim-treesitter.parsers")
                treesitter_parser_config.templ = {
                        install_info = {
                                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                                files = {"src/parser.c", "src/scanner.c"},
                                branch = "master",
                        },
                }
                vim.treesitter.language.register("templ", "templ")

                -- Autostart treesitter 
                vim.api.nvim_create_autocmd("FileType", {
                        desc = "Enable treesitter if a parser is available for the filetype of the current buffer",
                        group = vim.api.nvim_create_augroup("treesitter-auto-enable", { clear = true }),
                        callback = function(args)
                                local lang = vim.treesitter.language.get_lang(args.match)
                                if not lang or not vim.treesitter.language.add(lang) then return end
                                if vim.treesitter.query.get(lang, "highlights") then
                                        vim.treesitter.start(args.buf)
                                end
                        end
                })

                -- Disable semantic highlighting from the LSP, as they are provided by treesitter
                vim.api.nvim_create_autocmd("LspAttach", {
                        group = vim.api.nvim_create_augroup("lsp-disable-semantic-tokens", { clear = true }),
                        callback = function(ev)
                                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                                if client then
                                        client.server_capabilities.semanticTokensProvider = nil
                                end
                        end
                })
        end
}

