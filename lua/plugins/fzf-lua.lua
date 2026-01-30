---fzf-lua: fuzzy finder UI powered by the external `fzf` binary.
---Requires: `fzf` installed on Windows for pickers to work.
---Docs: https://github.com/ibhagwan/fzf-lua
return {
  "ibhagwan/fzf-lua",
  cmd = { "FzfLua" },
  dependencies = {
    -- Optional: pretty icons in the picker UI.
    "nvim-tree/nvim-web-devicons",
  },
  ---@module "fzf-lua"
  ---@type fzf-lua.Config|{}
  ---@diagnostic disable: missing-fields
  opts = require("config.fzf_lua"),
  ---@diagnostic enable: missing-fields
  keys = {
    { "<leader>Ff", function() require("fzf-lua").files() end, desc = "FzfLua: Files" },
    { "<leader>Fg", function() require("fzf-lua").live_grep() end, desc = "FzfLua: Live Grep" },
    { "<leader>Fb", function() require("fzf-lua").buffers() end, desc = "FzfLua: Buffers" },
    { "<leader>Fh", function() require("fzf-lua").help_tags() end, desc = "FzfLua: Help" },
  },
}

