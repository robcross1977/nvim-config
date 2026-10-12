---blink.cmp: completion UI/engine. LSP capabilities are registered automatically (vim.lsp.config("*")).
---.csproj/.fsproj NuGet completion now comes from easy-dotnet's ProjX LSP, so no custom source is needed.
---friendly-snippets provides a curated snippet library (C#, TypeScript, React, Next.js, etc.).
---Docs: https://github.com/saghen/blink.cmp
return {
  "saghen/blink.cmp",
  version = "1.*",
  build = "cargo build --release", -- compile the Rust fuzzy matcher from source
  dependencies = { "rafamadriz/friendly-snippets" },
  event = { "InsertEnter", "CmdlineEnter" },
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    fuzzy = { implementation = "prefer_rust" },
    keymap = { preset = "default" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      -- Syntax-highlight LSP completion labels (Tailwind/CSS colour swatches are on by default)
      menu = { draw = { treesitter = { "lsp" } } },
    },
    signature = { enabled = true },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
