-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Ensure critical tool dirs are in PATH.
-- Homebrew (tree-sitter CLI, curl, etc.) and dotnet global tools may be missing
-- when nvim is launched from a GUI or a shell that skips the full profile.
for _, dir in ipairs({
  "/opt/homebrew/bin",           -- Homebrew (Apple Silicon)
  "/usr/local/bin",              -- Homebrew (Intel)
  vim.fn.expand("~/.dotnet/tools"), -- dotnet global tools (dotnet-easydotnet / Roslyn)
}) do
  if vim.fn.isdirectory(dir) == 1 and not vim.env.PATH:find(dir, 1, true) then
    vim.env.PATH = dir .. ":" .. vim.env.PATH
  end
end

-- Indentation: 4 spaces, expand tabs to spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Always show sign column to prevent layout shift on diagnostics/git signs
vim.opt.signcolumn = "yes"

-- Show diagnostics as virtual lines (inline, below the offending line)
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})

-- Filetype detection for Razor files (Blazor/ASP.NET)
vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
  },
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = {
    colorscheme = { "tokyonight" },
  },
  checker = {
    enabled = true,
  },
})

