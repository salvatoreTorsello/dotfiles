return {
        {
                "nvim-mini/mini.nvim",
                event = "VeryLazy",
                config = function()
                        require('mini.pairs').setup()  -- Auto-pair insertion
                        require('mini.comment').setup()  -- Comment toggling
                        require('mini.surround').setup()  -- Surround text manipulation

                        -- Cursor and word
                        require('mini.cursorword').setup()  -- Highlight current word

                        -- Indentation
                        require('mini.indentscope').setup()  -- Visualize indentation

                        -- Git integration
                        require('mini.git').setup()  -- Inline git blame and signs

                        -- File management
                        require('mini.files').setup()  -- File explorer <kcite ref="38"/>

                        -- Highlight patterns like TODO, FIXME, HACK, NOTE
                        local hipatterns = require('mini.hipatterns')
                        hipatterns.setup({
                                highlighters = {
                                        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                                        fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                                        hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
                                        todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
                                        note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

                                        -- Highlight hex color strings (`#rrggbb`) using that color
                                        hex_color = hipatterns.gen_highlighter.hex_color(),
                                },
                        })
                end,
        },
}

