# Neovim Shortcuts

Leader key: `Space`

## Navigation & Files

| Key | Action |
|---|---|
| `<leader><space>` | Smart find files |
| `<leader>ff` | Find files |
| `<leader>fb` | Buffers |
| `<leader>fc` | Find config file |
| `<leader>/` | Grep |
| `<leader>e` | File explorer |

## LSP (TypeScript / .NET)

| Key | Action |
|---|---|
| `K` | Hover docs / JSDoc |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Find all usages / references |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `<leader>k` | Signature help |

## Diagnostics (Errors / Warnings)

| Key | Action |
|---|---|
| `<leader>d` | Show diagnostic on current line |
| `gl` | Show diagnostic on current line (alt) |
| `<leader>D` | List all diagnostics (picker) |
| `[d` | Jump to previous diagnostic |
| `]d` | Jump to next diagnostic |

## Terminal

| Key | Action |
|---|---|
| `<leader>t` | Toggle terminal |
| `Ctrl+/` | Toggle terminal (normal & terminal mode) |

## Buffers

| Key | Action |
|---|---|
| `<leader>bd` | Delete buffer |

## FzfLua (Alt Fuzzy Finder)

| Key | Action |
|---|---|
| `<leader>Ff` | FzfLua files |
| `<leader>Fg` | FzfLua live grep |
| `<leader>Fb` | FzfLua buffers |
| `<leader>Fh` | FzfLua help tags |

## .NET (easy-dotnet)

| Key | Action |
|---|---|
| `Ctrl+p` | Run .NET project |
| `T` | Open variable viewer (in debugger) |

## Other

| Key | Action |
|---|---|
| `<leader>uC` | Colorschemes |
| `<leader>sp` | Search plugin specs |

## Commands

| Command | Action |
|---|---|
| `:Dotnet` | .NET commands |
| `:Secrets` | .NET user secrets |
| `:Mason` | LSP server manager |
| `:Lazy` | Plugin manager |
