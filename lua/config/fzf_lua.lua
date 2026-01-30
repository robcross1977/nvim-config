---fzf-lua configuration.
---@module "config.fzf_lua"

---@type fzf-lua.Config|{}
---@diagnostic disable: missing-fields
return {
  fzf_colors = true, -- auto-generate from current colorscheme (TokyoNight)
  winopts = {
    height = 0.85,
    width = 0.85,
    preview = {
      layout = "flex",
      flip_columns = 120,
      scrollbar = "float",
    },
  },
  files = {
    hidden = true,
    fd_opts = "--color=never --hidden --type f --type l --exclude .git",
  },
  grep = {
    rg_glob = true,
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
  },
}
---@diagnostic enable: missing-fields

