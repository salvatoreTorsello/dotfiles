function ColorMyPencils(color)
        color = color or "rose-pine"
        vim.cmd.colorscheme(color)

        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

return {
        {
                "folke/tokyonight.nvim",
                as = "tokuonight",
                config = function()
                        require("tokyonight").setup({
                                -- your configuration comes here
                                -- or leave it empty to use the default settings
                                style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                                transparent = true, -- Enable this to disable setting the background color
                                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                                styles = {
                                        -- Style to be applied to different syntax groups
                                        -- Value is any valid attr-list value for `:help nvim_set_hl`
                                        comments = { italic = false },
                                        keywords = { italic = false },
                                        -- Background styles. Can be "dark", "transparent" or "normal"
                                        sidebars = "dark", -- style for sidebars, see below
                                        floats = "dark", -- style for floating windows
                                },
                        })
                        vim.cmd.colorscheme("tokyonight-night")
                end
        },
        {
                "rose-pine/neovim",
                as = "rose-pine",
                config = function()
                        require("rose-pine").setup({
                                disable_background = true, -- Enable transparent background
                                variants = { "main", "moon", "dawn" }, -- Available variants
                        })
                end
        }
}
