-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Ensure critical tool dirs are in PATH.
-- Homebrew (tree-sitter CLI, curl, etc.) and dotnet global tools may be missing
-- when nvim is launched from a GUI or a shell that skips the full profile.
local path_sep = vim.fn.has("win32") == 1 and ";" or ":"
for _, dir in ipairs({
  "/opt/homebrew/bin",           -- Homebrew (Apple Silicon)
  "/usr/local/bin",              -- Homebrew (Intel)
  vim.fn.expand("~/.dotnet/tools"), -- dotnet global tools (dotnet-easydotnet / Roslyn)
  vim.fn.expand("~/.cargo/bin"), -- Rust toolchain (cargo build for blink.cmp)
}) do
  if vim.fn.isdirectory(dir) == 1 and not vim.env.PATH:find(dir, 1, true) then
    vim.env.PATH = dir .. path_sep .. vim.env.PATH
  end
end

-- Indentation: 2 spaces by default, expand tabs to spaces (C#/Razor get 4 below)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_indent", { clear = true }),
  pattern = { "cs", "razor" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end,
})

-- Hybrid line numbers: absolute on the cursor line, relative everywhere else
vim.opt.number = true
vim.opt.relativenumber = true

-- Always show sign column to prevent layout shift on diagnostics/git signs
vim.opt.signcolumn = "yes"

-- Show diagnostics as virtual lines (inline, below the offending line).
-- Float: wrap long messages so nothing gets clipped at the window edge.
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
  float = {
    wrap = true,
    max_width = math.floor(vim.o.columns * 0.7), -- cap at 70% of screen width
  },
})

-- Filetype detection for Razor files (Blazor/ASP.NET)
vim.filetype.add({
  extension = {
    razor = "razor",
    cshtml = "razor",
  },
  -- .NET config files allow comments; treat them as JSONC so jsonls doesn't flag every comment
  pattern = {
    [".*/appsettings[^/]*%.json"] = "jsonc",
    [".*/launchSettings%.json"] = "jsonc",
  },
})

-- JSON: no wrapping, treesitter folds (za/zc/zo, zM/zR), all open by default
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_json", { clear = true }),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.wo.wrap = false
    vim.wo.conceallevel = 0 -- keep the quotes visible
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldlevel = 99
  end,
})

-- Pretty-print the buffer as JSON with jq. Works on minified JSON that snacks.bigfile has
-- stripped of highlighting/LSP, and restores the json filetype afterwards.
vim.keymap.set("n", "<leader>cj", function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local out = vim.fn.systemlist({ "jq", "--indent", "2", "." }, lines)
  if vim.v.shell_error ~= 0 then
    vim.notify("jq: " .. table.concat(out, "\n"), vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
  if vim.bo.filetype ~= "json" and vim.bo.filetype ~= "jsonc" then
    vim.bo.filetype = "json"
  end
end, { desc = "Pretty-print JSON (jq)" })

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

