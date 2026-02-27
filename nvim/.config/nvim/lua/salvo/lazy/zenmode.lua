return {
        "folke/zen-mode.nvim",
        config = function()
                vim.keymap.set("n", "<leader>zz", function()
                        require("zen-mode").setup {
                                window = {
                                        width = 80, -- or 90, adjust as needed
                                        options = {}
                                },
                        }
                        require("zen-mode").toggle()

                        -- Apply settings based on whether Zen mode is active
                        if vim.api.nvim_win_get_config(0).relative == "" then
                                -- Exiting Zen mode
                                vim.wo.wrap = false
                                vim.wo.number = true
                                vim.wo.rnu = true
                                vim.opt.colorcolumn = "0"
                        else
                                -- Entering Zen mode
                                vim.wo.wrap = false
                                vim.wo.number = false
                                vim.wo.rnu = false
                                vim.opt.colorcolumn = "0"
                        end
                        ColorMyPencils()
                end, { silent = true })
        end
}

