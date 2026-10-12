---which-key.nvim: displays a popup of available keybindings after pressing a prefix.
---Particularly useful for exploring <leader> mappings across all plugins.
---Docs: https://github.com/folke/which-key.nvim
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Group labels shown in the popup for key prefixes
    spec = {
      { "<leader>h", group = "git hunks" },
      { "<leader>x", group = "trouble / diagnostics" },
      { "<leader>F", group = "fzf-lua" },
      { "<leader>b", group = "buffer" },
      { "<leader>u", group = "ui" },
      { "<leader>s", group = "search / symbols" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>f", group = "find" },
      { "<leader>n", group = ".NET" },
      { "<leader>T", group = "test" },
    },
  },
}
