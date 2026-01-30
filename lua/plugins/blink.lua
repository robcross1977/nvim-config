---blink.cmp: completion UI/engine. Configured with easy-dotnet.nvim as a NuGet package completion source.
---Docs: https://github.com/saghen/blink.cmp
---easy-dotnet integration: https://github.com/GustavEikaas/easy-dotnet.nvim?tab=readme-ov-file
return {
  "saghen/blink.cmp",
  version = "*",
  ft = { "cs", "fs", "vb", "xml", "csproj", "fsproj", "razor", "cshtml", "typescript", "typescriptreact", "javascript", "javascriptreact" },
  ---@return nil
  config = function()
    require("blink.cmp").setup({
      fuzzy = { implementation = "prefer_rust_with_warning" },
      keymap = { preset = "default" },
      sources = {
        default = { "lsp", "easy-dotnet", "path" },
        providers = {
          ["easy-dotnet"] = {
            name = "easy-dotnet",
            enabled = true,
            module = "easy-dotnet.completion.blink",
            score_offset = 10000,
            async = true,
          },
        },
      },
    })
  end,
}

