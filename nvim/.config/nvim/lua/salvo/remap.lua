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

-- Switch beetween .c ah .h file  
-- vim.keymap.set('n', '<leader>f', ":execute 'e %<.' . (expand('%:e')=='c'?'h':'c')<CR>")
vim.keymap.set('n', '<leader>f', function()
        local ext = vim.fn.expand('%:e')
        local base_name = vim.fn.expand('%:p:r')

        -- If current file has .c, .cpp, or .C extension, switch to .h
        if ext == 'c' or ext == 'cpp' or ext == 'C' then
                vim.cmd('edit ' .. base_name .. '.h')
                -- If current file has .h extension, try switching to corresponding .c, .cpp, or .C
        elseif ext == 'h' then

                local c_file = vim.fn.glob(base_name .. '.c')
                local cpp_file = vim.fn.glob(base_name .. '.cpp')
                local C_file = vim.fn.glob(base_name .. '.C')

                if c_file ~= '' then
                        vim.cmd('edit ' .. c_file)
                elseif cpp_file ~= '' then
                        vim.cmd('edit ' .. cpp_file)
                elseif C_file ~= '' then
                        vim.cmd('edit ' .. C_file)
                else
                        print('No corresponding C/C++ file found')
                end
        else
                print('Unsupported extension: only .c, .cpp, .C, and .h files are supported')
        end
end)

-- Arrow key movements
vim.keymap.set("n", "<leader><Left>", ':bp<CR>')
vim.keymap.set("n", "<leader><Right>", ':bn<CR>')

-- Search and open the file with name equal to the word under the cursor in a
-- new virtical or floating window
-- Ensure the 'path' option includes subdirectories for header file search.
vim.o.path = vim.o.path .. ',**'

-- Quickfix w/ diagnostics
vim.keymap.set('n', '<leader>xx', function()
	local diagnostics = vim.diagnostic.get(nil)
	local items = {}
	for _, d in ipairs(diagnostics) do
		local text = d.message
		if d.source then text = '[' .. d.source .. '] ' .. text end
		if d.code   then text = text .. ' (' .. tostring(d.code) .. ')' end
		table.insert(items, {
			bufnr = d.bufnr,
			lnum  = d.lnum + 1,
			col   = d.col + 1,
			text  = text,
			type  = ({ 'E', 'W', 'I', 'N' })[d.severity] or 'E',
		})
	end
	vim.fn.setqflist({}, ' ', { title = 'Diagnostics', items = items })
	vim.cmd('copen')
end,
{ desc = "Open quickfix list with LSP diagnostics" }
)
