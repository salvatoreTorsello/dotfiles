return {
	'nvimtools/none-ls.nvim',
	ft = {
		'c',
		'cpp',
	},
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		require('null-ls').setup({
			debug = true,

			sources = {
				require('salvo.lazy.none-ls-sources.cpptestcli'),
				require('salvo.lazy.none-ls-sources.cpptestcli-suppress'),
			},
		})
	end,
}
