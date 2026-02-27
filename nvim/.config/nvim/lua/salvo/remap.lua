vim.g.mapleader = " "

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", vim.cmd.NvimTreeToggle)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
        require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
        require("vim-with-me").StopVimWithMe()
end)

-- vim.keymap.set('n', '<leader>o', '<Cmd>b#<CR>')
vim.keymap.set('n', '<leader>o', '<C-o>')

-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("x", "p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
        vim.cmd("so")
end)

-- ASCII Doc preview
vim.keymap.set('n', '<Leader>cp', ':AsciiDocPreview<CR>', { desc = 'Preview AsciiDoc document' })

-- LSP config
-- vim.keymap.set("n", "<leader>[", ':ClangdSwitchSourceHeader<CR>', { desc = 'Switch to source or header file' })

-- Switch beetween .c ah .h file  
vim.keymap.set('n', '<leader>f', ":execute 'e %<.' . (expand('%:e')=='c'?'h':'c')<CR>")

-- Arrow key movements
vim.keymap.set("n", "<leader><Left>", ':bp<CR>')
vim.keymap.set("n", "<leader><Right>", ':bn<CR>')

-- Search and open the file with name equal to the word under the cursor in a
-- new virtical or floating window
-- Ensure the 'path' option includes subdirectories for header file search.
vim.o.path = vim.o.path .. ',**'

-- Vertical split mapping (unchanged)
vim.keymap.set('n', '<leader>ghv', function()
        local file = vim.fn.expand('<cfile>'):gsub('[\'"]', '')
        local found_file = vim.fn.findfile(file, '.;//')
        if found_file ~= '' and vim.fn.filereadable(found_file) == 1 then
                vim.cmd('vsplit ' .. found_file)
        else
                print("File not found: " .. file)
        end
end, { silent = true })

-- Floating window mapping
vim.keymap.set('n', '<leader>ghf', function()
        local file = vim.fn.expand('<cfile>'):gsub('[\'"]', '')
        local found_file = vim.fn.findfile(file, '.;//')
        if found_file ~= '' and vim.fn.filereadable(found_file) == 1 then
                local buf
                -- Check if a buffer with the file already exists.
                if vim.fn.bufexists(found_file) == 1 then
                        buf = vim.fn.bufnr(found_file)
                else
                        buf = vim.api.nvim_create_buf(false, true)
                        vim.api.nvim_buf_set_name(buf, found_file)
                        local lines = vim.fn.readfile(found_file)
                        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                        vim.cmd('file ' .. found_file)
                end

                local width = math.floor(vim.o.columns * 0.8)
                local height = math.floor(vim.o.lines * 0.8)
                local row = math.floor((vim.o.lines - height) / 2)
                local col = math.floor((vim.o.columns - width) / 2)
                local opts = {
                        relative = 'editor',
                        width = width,
                        height = height,
                        row = row,
                        col = col,
                        style = 'minimal',
                        border = 'single',
                }
                vim.api.nvim_open_win(buf, true, opts)
        else
                print("File not found: " .. file)
        end
end, { silent = true })


