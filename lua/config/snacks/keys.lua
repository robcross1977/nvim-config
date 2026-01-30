---snacks.nvim keymaps.
---@module "config.snacks.keys"

---Closes dashboard windows before opening terminal.
local function toggle_terminal()
  local dominated_by_dashboard = vim.tbl_filter(function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    return vim.bo[buf].filetype == "snacks_dashboard"
  end, vim.api.nvim_list_wins())

  if #dominated_by_dashboard > 0 then
    vim.cmd("enew")
    for _, win in ipairs(dominated_by_dashboard) do
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
  Snacks.terminal()
end

---@type LazyKeysSpec[]
return {
  { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
  { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
  { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
  { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
  { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
  { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
  { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
  { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search Plugin Spec" },
  { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
  { "<leader>t", toggle_terminal, desc = "Toggle Terminal" },
  { "<c-/>", toggle_terminal, desc = "Toggle Terminal", mode = { "n", "t" } },
  { "<c-_>", toggle_terminal, desc = "which_key_ignore", mode = { "n", "t" } },
  -- Diagnostics
  { "<leader>d", function() vim.diagnostic.open_float() end, desc = "Show Diagnostic" },
  { "<leader>D", function() Snacks.picker.diagnostics() end, desc = "All Diagnostics" },
  { "[d", function() vim.diagnostic.goto_prev() end, desc = "Previous Diagnostic" },
  { "]d", function() vim.diagnostic.goto_next() end, desc = "Next Diagnostic" },
}

