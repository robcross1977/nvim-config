---Healthcheck helper for easy-dotnet.nvim.
---This lives in your config so `:checkhealth easy-dotnet` works even if the plugin is lazy-loaded.
local M = {}

---Run `:checkhealth easy-dotnet`.
---@return nil
function M.check()
  local health = vim.health

  health.start("easy-dotnet")

  if vim.fn.executable("dotnet") == 1 then
    health.ok("Found `dotnet` in PATH")
  else
    health.error("Missing `dotnet` in PATH")
  end

  local ok_require = pcall(require, "easy-dotnet")
  if ok_require then
    health.ok("`require('easy-dotnet')` works")
  else
    health.warn("`easy-dotnet.nvim` not loaded yet. Open a `.cs` file or run `:Lazy load easy-dotnet.nvim`.")
  end
end

return M

