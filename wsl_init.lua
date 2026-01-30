-- WSL-specific Neovim configuration
-- Copy this to ~/.config/nvim/init.lua in WSL

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

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

-- Setup lazy.nvim (customize as needed for WSL)
require("lazy").setup({
  spec = {
    -- Add your WSL-specific plugins here
  },
  install = {
    colorscheme = { "default" },
  },
})
