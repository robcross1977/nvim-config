---tokyonight.nvim: colorscheme.
---Docs: https://github.com/folke/tokyonight.nvim
return {
  "folke/tokyonight.nvim",
  priority = 1000,
  lazy = false,
  ---@type tokyonight.Config
  opts = {
    style = "night",
  },
  ---@return nil
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight-night")
  end,
}

