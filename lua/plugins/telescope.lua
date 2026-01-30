---telescope.nvim: optional picker UI; easy-dotnet recommends having a picker installed.
---Docs: https://github.com/nvim-telescope/telescope.nvim
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ---@return nil
  config = function()
    require("telescope").setup({})
  end,
}

