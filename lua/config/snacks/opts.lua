---snacks.nvim options.
---Keeps the plugin spec small and makes the config easy to tweak.
---@module "config.snacks.opts"
---@type snacks.Config

---Check if a path exists and is a directory.
---@param path string
---@return boolean
local function is_valid_dir(path)
  if not path or path == "" then
    return false
  end
  local stat = vim.uv and vim.uv.fs_stat or vim.loop.fs_stat
  if not stat then
    return false
  end
  local ok, result = pcall(stat, path)
  return ok and result and result.type == "directory"
end

local explorer_config = { enabled = true }

-- Disable explorer if config path is invalid (prevents WSL/Windows path mismatch errors)
local config_path = vim.fn.stdpath("config")
if not is_valid_dir(config_path) then
  explorer_config.enabled = false
end

return {
  bigfile = { enabled = true },
  terminal = { shell = "bash", win = { wo = { winbar = "" } } },
  dashboard = { enabled = true },
  explorer = explorer_config,
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true, timeout = 3000 },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        -- `A` in the explorer: create a .NET item (class/interface/…) from easy-dotnet templates
        win = { list = { keys = { ["A"] = "explorer_add_dotnet" } } },
        actions = {
          explorer_add_dotnet = function(picker)
            require("easy-dotnet").create_item(picker:dir())
          end,
        },
      },
    },
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
}

