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
| `<leader>ca` | Code actions / suggestions (normal & visual) |
| `<leader>k` | Signature help |

## Diagnostics (Errors / Warnings)

| Key | Action |
|---|---|
| `gl` | Show diagnostic float on current line (LSP) |
| `<leader>d` | Show diagnostic float on current line |
| `<leader>D` | List all diagnostics (picker) |
| `[d` | Jump to previous diagnostic |
| `]d` | Jump to next diagnostic |

> Tip: `gl` or `<leader>d` to read the error → `<leader>ca` to pick a fix.

## Trouble (Diagnostics List)

| Key | Action |
|---|---|
| `<leader>xx` | Toggle all diagnostics (Trouble) |
| `<leader>xX` | Toggle buffer diagnostics (Trouble) |
| `<leader>xL` | Toggle location list (Trouble) |
| `<leader>xQ` | Toggle quickfix list (Trouble) |
| `]x` | Next trouble item (or next quickfix if closed) |
| `[x` | Prev trouble item (or prev quickfix if closed) |

## Completion (blink.cmp)

| Key | Action |
|---|---|
| `<C-space>` | Show completions |
| `<C-e>` | Hide completions |
| `<CR>` or `<C-y>` | Accept selected item |
| `<Tab>` / `<S-Tab>` | Select next / prev item |
| `<C-n>` / `<C-p>` | Select next / prev item |
| `<C-b>` / `<C-f>` | Scroll docs up / down |

## Git (gitsigns)

| Key | Action |
|---|---|
| `]h` | Next git hunk |
| `[h` | Prev git hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hd` | Diff this |
| `<leader>hD` | Diff this (cached) |
| `ih` | Select hunk (visual/operator text object) |

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
| `:Trouble` | Open Trouble diagnostics panel |
