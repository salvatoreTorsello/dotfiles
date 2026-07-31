return {
        {
                "tpope/vim-fugitive",
                config = function()
                        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

                        local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

                        local autocmd = vim.api.nvim_create_autocmd
                        autocmd("BufWinEnter", {
                                group = ThePrimeagen_Fugitive,
                                pattern = "*",
                                callback = function()
                                        if vim.bo.ft ~= "fugitive" then
                                                return
                                        end

                                        local bufnr = vim.api.nvim_get_current_buf()
                                        local opts = {buffer = bufnr, remap = false}

                                        vim.api.nvim_win_set_height(0, math.floor(vim.o.lines * 0.25))
                                        vim.keymap.set("n", "<leader>p", function()
                                                vim.cmd.Git('push')
                                        end, opts)

                                        -- rebase always
                                        vim.keymap.set("n", "<leader>P", function()
                                                vim.cmd.Git({'pull',  '--rebase'})
                                        end, opts)

                                        -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                                        -- needed if i did not set the branch up correctly
                                        vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
                                end,
                        })


                        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
                        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
                end
        },
        {
                "sindrets/diffview.nvim",
                dependencies = { "nvim-lua/plenary.nvim" },
                cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
                config = function()
                        require("diffview").setup()

                        vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>")
                        vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<CR>")
                        vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<CR>")
                        vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory %<CR>")
                end
        },
}
