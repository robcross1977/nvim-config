-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Indentation: 4 spaces, expand tabs to spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

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

