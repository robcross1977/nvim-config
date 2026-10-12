---conform.nvim: auto-formatter with format-on-save support.
---  * C#: csharpier (Mason)
---  * JS/TS/CSS/JSON/MD/…: Biome when the project has a biome.json, else oxfmt when it has an
---    .oxfmtrc, else Prettier (the project's node_modules copy if present, else Mason's)
---  * ESLint `--fix` runs first on save when the ESLint LSP is attached
---Falls back to LSP formatting for everything else.
---Toggle format-on-save with <leader>uf (global) / <leader>uF (buffer).
---Docs: https://github.com/stevearc/conform.nvim
local web = { "biome-check", "oxfmt", "prettier", stop_after_first = true }

---@param bufnr integer
---@return nil
local function eslint_fix_all(bufnr)
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })[1]
  if not client then
    return
  end
  client:request_sync("workspace/executeCommand", {
    command = "eslint.applyAllFixes",
    arguments = { { uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] } },
  }, 3000, bufnr)
end

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "x" },
      desc = "Format buffer/selection",
    },
    {
      "<leader>uf",
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
      end,
      desc = "Toggle format on save",
    },
    {
      "<leader>uF",
      function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        vim.notify("Format on save (buffer): " .. (vim.b.disable_autoformat and "off" or "on"))
      end,
      desc = "Toggle format on save (buffer)",
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      cs = { "csharpier" },
      -- csharpier 1.x also formats MSBuild files; leave other XML alone
      xml = function(bufnr)
        local name = vim.api.nvim_buf_get_name(bufnr)
        local is_msbuild = name:match("%.[cf]sproj$") or name:match("%.props$") or name:match("%.targets$")
        return is_msbuild and { "csharpier" } or {}
      end,
      javascript = web,
      javascriptreact = web,
      typescript = web,
      typescriptreact = web,
      json = web,
      jsonc = web,
      css = web,
      scss = { "prettier" },
      html = { "prettier" },
      graphql = web,
      markdown = { "prettier" },
      yaml = { "prettier" },
    },
    formatters = {
      -- Only use Biome / oxfmt when the project is configured for them.
      ["biome-check"] = { require_cwd = true },
      oxfmt = { require_cwd = true },
    },
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      eslint_fix_all(bufnr)
      return { timeout_ms = 3000, lsp_format = "fallback" }
    end,
  },
}
