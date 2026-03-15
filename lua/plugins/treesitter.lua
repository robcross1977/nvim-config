---nvim-treesitter: parser manager + syntax highlighting.
---Pinned to `master` branch (old stable API) for Neovim 0.11 compatibility.
---The current HEAD ("main") is a full rewrite that requires Neovim 0.12 nightly.
---
---nvim-treesitter-textobjects: smart text objects and motions based on the syntax tree.
---Now has its own independent setup + manual keymaps (no longer via nvim-treesitter.configs).
---
---Docs: https://github.com/nvim-treesitter/nvim-treesitter/tree/master
---      https://github.com/nvim-treesitter/nvim-treesitter-textobjects
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- locked stable branch; supports Neovim 0.11 + old configs API
    lazy = false,
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    ---@return nil
    config = function()
      -- easy-dotnet language injections rely on these parsers (per README).
      -- razor parser provides syntax highlighting for .razor and .cshtml files.
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c_sharp", "json", "xml", "sql", "razor", "html", "css",
          "typescript", "tsx", "javascript", "jsdoc", "haskell",
        },
        highlight = { enable = true },
        -- textobjects are now configured independently below; don't pass them here
      })

      -- nvim-treesitter-textobjects: global options (no keymaps here)
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
}
