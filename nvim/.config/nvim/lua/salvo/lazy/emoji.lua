return {
  "Allaman/emoji.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("emoji").setup({
      -- Configuration options here
    })
  end,
}
