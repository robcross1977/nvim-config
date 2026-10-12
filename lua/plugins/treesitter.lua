---nvim-treesitter (`main` branch): parser installer + query collection for Neovim 0.12+.
---The old `master` branch is frozen and does not support Neovim 0.12, so this uses the rewrite:
---  * parsers are installed explicitly via require("nvim-treesitter").install()
---  * highlighting/indent/folds are started per buffer with a FileType autocmd
---  * requires the `tree-sitter` CLI (0.26.1+, via Homebrew) and a C compiler
---
---nvim-treesitter-textobjects (`main` branch): smart text objects and motions based on the syntax tree.
---
---nvim-ts-autotag: auto-close and auto-rename paired HTML/JSX/TSX tags.
---
---Docs: https://github.com/nvim-treesitter/nvim-treesitter
---      https://github.com/nvim-treesitter/nvim-treesitter-textobjects
---      https://github.com/windwp/nvim-ts-autotag

-- Parsers to keep installed.
local parsers = {
  -- .NET
  "c_sharp", "razor", "xml", "sql", "json",
  -- Web / TypeScript / React / React Native / Next.js
  "typescript", "tsx", "javascript", "jsdoc", "html", "css", "scss",
  "graphql", "prisma", "styled", "regex", "json5", "yaml", "toml",
  -- General
  "markdown", "markdown_inline", "lua", "luadoc", "vim", "vimdoc", "query",
  "bash", "dockerfile", "gitignore", "diff", "haskell",
}

-- Languages that keep Vim's built-in indent instead of treesitter's.
local no_ts_indent = { c_sharp = true, razor = true }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- does not support lazy-loading
    build = ":TSUpdate",
    ---@return nil
    config = function()
      local ts = require("nvim-treesitter")
      ts.install(parsers) -- async; no-op for parsers already installed

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or not vim.treesitter.language.add(lang) then
            return -- no parser installed for this filetype
          end
          vim.treesitter.start(args.buf, lang)
          -- Treesitter indent is experimental and breaks C#/Razor indentation (per easy-dotnet health check)
          if not no_ts_indent[lang] then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    ---@return nil
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true, -- auto-jump to next match if not under cursor
        },
        move = {
          set_jumps = true, -- add movements to jumplist (Ctrl-O/Ctrl-I)
        },
      })

      local sel = require("nvim-treesitter-textobjects.select")
      local mov = require("nvim-treesitter-textobjects.move")
      local swp = require("nvim-treesitter-textobjects.swap")

      -- ── Select (works in visual and operator-pending mode) ──────────────
      local select_maps = {
        af = "@function.outer",
        ["if"] = "@function.inner",
        ac = "@class.outer",
        ic = "@class.inner",
        aa = "@parameter.outer",
        ia = "@parameter.inner",
        ab = "@block.outer",
        ib = "@block.inner",
      }
      for key, query in pairs(select_maps) do
        vim.keymap.set({ "x", "o" }, key, function()
          sel.select_textobject(query, "textobjects")
        end, { desc = "TS: " .. query })
      end

      -- ── Move (next/prev function and class starts/ends) ─────────────────
      vim.keymap.set("n", "]m", function() mov.goto_next_start("@function.outer",    "textobjects") end, { desc = "Next function start" })
      vim.keymap.set("n", "]c", function() mov.goto_next_start("@class.outer",       "textobjects") end, { desc = "Next class start" })
      vim.keymap.set("n", "]M", function() mov.goto_next_end("@function.outer",      "textobjects") end, { desc = "Next function end" })
      vim.keymap.set("n", "]C", function() mov.goto_next_end("@class.outer",         "textobjects") end, { desc = "Next class end" })
      vim.keymap.set("n", "[m", function() mov.goto_previous_start("@function.outer","textobjects") end, { desc = "Prev function start" })
      vim.keymap.set("n", "[c", function() mov.goto_previous_start("@class.outer",   "textobjects") end, { desc = "Prev class start" })
      vim.keymap.set("n", "[M", function() mov.goto_previous_end("@function.outer",  "textobjects") end, { desc = "Prev function end" })
      vim.keymap.set("n", "[C", function() mov.goto_previous_end("@class.outer",     "textobjects") end, { desc = "Prev class end" })

      -- ── Swap (reorder parameters/arguments) ─────────────────────────────
      vim.keymap.set("n", "<leader>a", function() swp.swap_next("@parameter.inner")     end, { desc = "Swap with next parameter" })
      vim.keymap.set("n", "<leader>A", function() swp.swap_previous("@parameter.inner") end, { desc = "Swap with prev parameter" })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
