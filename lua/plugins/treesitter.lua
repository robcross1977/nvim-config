---nvim-treesitter: tree-sitter parser manager + query bundles for Neovim.
---Docs: https://github.com/nvim-treesitter/nvim-treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  ---@return nil
  config = function()
    local ok, treesitter = pcall(require, "nvim-treesitter")
    if not ok then
      return
    end

    -- easy-dotnet language injections rely on these parsers (per README).
    -- razor parser provides syntax highlighting for .razor and .cshtml files.
    treesitter.install({ "c_sharp", "json", "xml", "sql", "razor", "html", "css", "typescript", "tsx", "javascript", "jsdoc" })
  end,
}

