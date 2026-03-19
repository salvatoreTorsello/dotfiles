return {
        {
                "andythigpen/nvim-coverage",
                event = "VeryLazy",
                dependencies = {
                        "nvim-lua/plenary.nvim"
                },
                config = function()
                        require('coverage').setup({
                                auto_reload = true,
                                commands = true, -- create commands
                                highlights = {
                                        -- customize highlight groups created by the plugin
                                        covered = { fg = "#A6E3A1" },   -- supports style, fg, bg, sp (see :h highlight-gui)
                                        uncovered = { fg = "#F38BA8" },
                                        partial = { fg = "#F9E2AF" },
                                },
                                signs = {
                                        -- use your own highlight groups or text markers
                                        covered = { hl = "CoverageCovered", text = "▎" },
                                        uncovered = { hl = "CoverageUncovered", text = "▎" },
                                },
                                summary = {
                                        -- customize the summary pop-up
                                        min_coverage = 80.0,      -- minimum coverage threshold (used for highlighting)
                                },
                                lang = {
                                        cpp = {
                                                coverage_file = "build-qemu/report.info"
                                        }
                                        -- customize language specific settings
                                },
                        })
                end
        }
}

