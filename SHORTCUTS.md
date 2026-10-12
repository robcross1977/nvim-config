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
| `<leader>e` | File explorer (`A` inside it: new .NET item from template) |

## LSP (TypeScript / React / .NET)

| Key | Action |
|---|---|
| `K` | Hover docs / JSDoc |
| `gd` | Go to definition (picker) |
| `gD` | Go to declaration |
| `gi` | Go to implementation (picker) |
| `gy` | Go to type definition (picker) |
| `gr` | Find all usages / references (picker) |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions / suggestions (normal & visual) |
| `<leader>cR` | Rename file (updates imports) |
| `<leader>cf` | Format buffer / selection |
| `<leader>cj` | Pretty-print JSON with jq (fixes minified JSON opened as "bigfile") |
| `<leader>ss` / `<leader>sS` | Document / workspace symbols |
| `<leader>k` | Signature help |
| `<leader>uh` | Toggle inlay hints |
| `<leader>uf` / `<leader>uF` | Toggle format on save (global / buffer) |

## TypeScript / JavaScript

TS 7+ projects use the native `tsc --lsp`; everything else uses vtsls. ESLint, Biome, Oxlint and Tailwind attach only when the project uses them. Format on save: ESLint fix → Biome / oxfmt / Prettier (whichever the project is set up for).

| Key | Action |
|---|---|
| `<leader>co` | Organize imports |
| `<leader>cM` | Add missing imports |
| `<leader>cu` | Remove unused imports |
| `<leader>cD` | Fix all (TS) |
| `<leader>cE` | ESLint fix all |
| `gR` | File references (vtsls) |
| `<leader>cV` | Select workspace TypeScript version (vtsls) |

## Diagnostics (Errors / Warnings)

| Key | Action |
|---|---|
| `gl` | Show diagnostic float on current line |
| `<leader>D` | List all diagnostics (picker) |
| `[d` | Jump to previous diagnostic |
| `]d` | Jump to next diagnostic |

> Tip: `gl` to read the error → `<leader>ca` to pick a fix.

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
| `<leader>hs` | Stage / unstage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
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
| `Ctrl+p` | Run default project |
| `<leader>nr` / `<leader>nR` | Run / run with launch profile |
| `<leader>nw` | Watch (hot reload) |
| `<leader>nd` / `<leader>nD` | Debug project / attach to process |
| `<leader>nb` / `<leader>nB` | Build project / solution → quickfix |
| `<leader>nt` / `<leader>nT` | Test runner window / test solution |
| `<leader>ne` / `<leader>nE` | Workspace errors / warnings |
| `<leader>na` | Add NuGet package |
| `<leader>no` | Outdated packages (then `<leader>pu` / `<leader>pa` to upgrade) |
| `<leader>nn` | New from template |
| `<leader>ns` | Select solution |
| `<leader>nx` / `<leader>nc` | Restore / clean |
| `<leader>nS` | User secrets |
| `<leader>ar` | Add project reference (in .csproj) |
| `T` | Open variable viewer (in debugger) |

## Debugging (nvim-dap)

.NET configs come from easy-dotnet; JS/TS has Node, attach, Next.js server and Chrome configs. A project's `.vscode/launch.json` is picked up too.

| Key | Action |
|---|---|
| `F5` / `Shift+F5` | Start or continue / stop |
| `F9` or `<leader>db` | Toggle breakpoint |
| `F10` / `F11` / `Shift+F11` | Step over / into / out |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dl` | Logpoint |
| `<leader>dC` | Run to cursor |
| `<leader>dL` | Run last |
| `<leader>dt` | Terminate |
| `<leader>dX` | Clear breakpoints |
| `<leader>dr` | Toggle REPL |
| `<leader>dk` / `<leader>dj` | Stack frame up / down |
| `<leader>du` | Toggle debug UI |
| `<leader>de` | Eval expression (normal & visual) |

## Testing (neotest: .NET, Vitest, Jest)

| Key | Action |
|---|---|
| `<leader>Tt` | Run nearest test |
| `<leader>Tf` | Run file |
| `<leader>TA` | Run all (cwd) |
| `<leader>Tl` | Run last |
| `<leader>Td` | Debug nearest test |
| `<leader>Tw` | Watch file |
| `<leader>Ts` | Summary |
| `<leader>To` / `<leader>TO` | Output / output panel |
| `<leader>TS` | Stop |
| `]t` / `[t` | Next / prev failed test |

## Other

| Key | Action |
|---|---|
| `<leader>uC` | Colorschemes |
| `<leader>sp` | Search plugin specs |

## Commands

| Command | Action |
|---|---|
| `:Dotnet` | .NET commands (`:Dotnet ef …`, `:Dotnet diagnostic`, …) |
| `:Secrets` | .NET user secrets |
| `:Mason` | LSP server manager |
| `:Lazy` | Plugin manager |
| `:Trouble` | Open Trouble diagnostics panel |
