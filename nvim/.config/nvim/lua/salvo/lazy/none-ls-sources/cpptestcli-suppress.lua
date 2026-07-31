local null_ls = require 'null-ls'

-- Get all cpptestcli diagnostics for the given line
local function line_diagnostics(params)
	local diagnostics = {}
	for _, d in ipairs(vim.diagnostic.get(params.bufnr, { lnum = params.row - 1 })) do
		if d.source == "cpptestcli" then
			table.insert(diagnostics, d)
		end
	end
	return diagnostics
end

-- Generate a cpptestcli suppress code action for a given diagnostic
local function generate_suppress_action(params, diagnostic)
	local lines = vim.api.nvim_buf_get_lines(params.bufnr, diagnostic.lnum, diagnostic.lnum + 1, false)
	local eol = #lines[1]

	return {
		title = "Suppress " .. diagnostic.code .. " violation",
		action = function()
			vim.api.nvim_buf_set_text(
				params.bufnr,
				diagnostic.lnum, eol,
				diagnostic.lnum, eol,
				{ ' /* parasoft-suppress ' .. diagnostic.code .. ' "" */' }
			)
		end,
	}
end

-- Collect all cpptestcli diagnostics, generate code actians for each one
local function code_actions_handler(params)
	local actions = {}

	local diagnostics = line_diagnostics(params)
	if vim.tbl_isempty(diagnostics) then
		return actions
	end

	for _, d in ipairs(diagnostics) do
		table.insert(actions, generate_suppress_action(params, d))
	end

	return actions
end

local cpptestcli_suppress = {
	name = "cpptestcli suppress",
	method = null_ls.methods.CODE_ACTION,
	filetypes = { "c" },
	generator_opts = { handler = code_actions_handler },
	generator = { fn = code_actions_handler },
}

return cpptestcli_suppress
