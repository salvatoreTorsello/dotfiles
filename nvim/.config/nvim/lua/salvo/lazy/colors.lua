return {
        {
                "folke/tokyonight.nvim",
                as = "tokyonight",
                config = function()
                        require("tokyonight").setup({
                                style = "storm",
                                transparent = true,
                                terminal_colors = true,
                                styles = {
                                        comments = { italic = false },
                                        keywords = { italic = false },
                                        sidebars = "dark",                                         
                                        floats = "dark",
                        },
                        })
                        vim.cmd.colorscheme("tokyonight-night")
                end
        },
}
