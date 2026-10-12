---gitsigns.nvim: git decorations, hunk navigation, blame, and diff.
---Docs: https://github.com/lewis6991/gitsigns.nvim
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local opts = { buffer = bufnr }

      -- Hunk navigation
      vim.keymap.set("n", "]h", function() gs.nav_hunk("next") end, vim.tbl_extend("force", opts, { desc = "Next git hunk" }))
      vim.keymap.set("n", "[h", function() gs.nav_hunk("prev") end, vim.tbl_extend("force", opts, { desc = "Prev git hunk" }))

      -- Hunk actions
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, vim.tbl_extend("force", opts, { desc = "Stage/unstage hunk" }))
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, vim.tbl_extend("force", opts, { desc = "Reset hunk" }))
      vim.keymap.set("n", "<leader>hS", gs.stage_buffer, vim.tbl_extend("force", opts, { desc = "Stage buffer" }))
      vim.keymap.set("n", "<leader>hR", gs.reset_buffer, vim.tbl_extend("force", opts, { desc = "Reset buffer" }))
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Preview hunk" }))
      vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, vim.tbl_extend("force", opts, { desc = "Blame line" }))
      vim.keymap.set("n", "<leader>hd", gs.diffthis, vim.tbl_extend("force", opts, { desc = "Diff this" }))
      vim.keymap.set("n", "<leader>hD", function() gs.diffthis("~") end, vim.tbl_extend("force", opts, { desc = "Diff this (cached)" }))

      -- Text object: select hunk in visual/operator mode with ih
      vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", vim.tbl_extend("force", opts, { desc = "Select hunk" }))
    end,
  },
}
