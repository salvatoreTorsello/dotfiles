return {
        "nvim-telescope/telescope.nvim",

        tag = "0.1.5",

        dependencies = {
        "nvim-lua/plenary.nvim"
        },

        config = function()
                require('telescope').setup({

                    defaults = {
                        vimgrep_arguments = {
                            "rg",
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            -- "--smart-case",
                            -- "--no-ignore",
                            "--no-hidden"
                        },
                    }
                })
                local builtin = require('telescope.builtin')
                vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
                vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
                vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
                vim.keymap.set('n', '<leader>pws', function()
                    local word = vim.fn.expand("<cword>")
                    builtin.grep_string({ search = word })
                end)
                vim.keymap.set('n', '<leader>pWs', function()
                    local word = vim.fn.expand("<cWORD>")
                    builtin.grep_string({ search = word })
                end)
                vim.keymap.set('n', '<leader>ps', function()
                    local query = vim.fn.input("Grep > ")
                    if query ~= "" then
                        builtin.grep_string({ search = query })
                    end
                end)
                vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
                vim.keymap.set('n', '<leader>xd', "<cmd>Telescope diagnostics<cr>")
        end
}

