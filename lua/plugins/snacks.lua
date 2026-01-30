---snacks.nvim: QoL suite (dashboard, picker, explorer, notifier, etc.).
---The dashboard is what provides the startup screen with actions like "Files" and "Lazy".
---Docs: https://github.com/folke/snacks.nvim
local opts = require("config.snacks.opts")
local keys = require("config.snacks.keys")
local init = require("config.snacks.init")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = opts,
  keys = keys,
  init = init,
}

