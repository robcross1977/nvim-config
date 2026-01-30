---nvim-lspconfig + mason: LSP server management and configuration.
---mason auto-installs servers; mason-lspconfig auto-enables them via vim.lsp.enable().
---Docs: https://github.com/neovim/nvim-lspconfig
---      https://github.com/mason-org/mason.nvim
---      https://github.com/mason-org/mason-lspconfig.nvim
return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "ts_ls" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local opts = { buffer = buf }

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },
}
