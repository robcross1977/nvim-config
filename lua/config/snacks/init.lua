---snacks.nvim startup behavior.
---@module "config.snacks.init"

---Show the Snacks dashboard on startup when no file is provided.
---@return nil
return function()
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local is_clean_start = vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == ""
      if not is_clean_start then
        return
      end

      vim.schedule(function()
        if _G.Snacks and Snacks.dashboard then
          Snacks.dashboard()
        end
      end)
    end,
  })
end

