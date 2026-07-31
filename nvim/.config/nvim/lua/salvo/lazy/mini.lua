return {
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

                -- File management
                require('mini.files').setup()  -- File explorer <kcite ref="38"/>

                -- Notification
                require('mini.notify').setup()

                -- Show line diff
		require('mini.diff').setup({
			view = {
				style = 'number',
			}
		})

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

                -- mini.ai
                require('mini.ai').setup()

                -- mini.statusline
                require('mini.statusline').setup({
                        content = {
                                active = function()
                                        local git_info = function(args)
                                                if vim.fn.exists('*FugitiveHead') == 0 or vim.fn['FugitiveHead']() == '' then
                                                        return ''
                                                end
                                                return ' ' .. vim.fn['FugitiveHead']()
                                        end

                                        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                                        local git           = git_info()
                                        local modified      = '%m%r'  -- Modified + read-only
                                        local filename      = '%f'
                                        local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
                                        local location      = '%l:%c'

                                        return MiniStatusline.combine_groups({
                                                { hl = mode_hl,                  strings = { mode } },
                                                { hl = 'MiniStatuslineDevinfo',  strings = { git .. modified } },
                                                '%<', -- Mark general truncate point
                                                { hl = 'MiniStatuslineFilename', strings = { filename } },
                                                '%=', -- End left alignment
                                                { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                                                { hl = mode_hl,                  strings = { location } },
                                        })
                                end,
                                inactive = function ()
                                        local git           = MiniStatusline.section_git({ trunc_width = 40 })
                                        local modified      = '%m%r'  -- Modified + read-only
                                        local filename      = '%f'
                                        local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })

                                        return MiniStatusline.combine_groups({
                                                { hl = 'MiniStatuslineDevinfo',  strings = { git, modified } },
                                                '%<', -- Mark general truncate point
                                                { hl = 'MiniStatuslineFilename', strings = { filename } },
                                                '%=', -- End left alignment
                                                { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                                        })
                                end
                        }
                })

        end
}
