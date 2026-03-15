---mini.nvim modules: pairs, surround, comment.
---mini.pairs:   auto-close brackets, quotes, etc.
---mini.surround: add/delete/replace surrounding chars (sa, sd, sr, etc.)
---mini.comment:  gc/gcc to toggle comments; ts-context-commentstring handles
---               mixed-language files like Razor (.razor / .cshtml).
---Docs: https://github.com/echasnovski/mini.nvim
---      https://github.com/JoosepAlviste/nvim-ts-context-commentstring
return {
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    -- loaded on first use of any surround key
    keys = { "sa", "sd", "sf", "sF", "sh", "sr", "sn" },
    opts = {
      -- sa = add surrounding, sd = delete, sr = replace, sf/sF = find, sh = highlight
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
      },
    },
  },
  {
    -- Must be loaded after nvim-ts-context-commentstring
    "echasnovski/mini.comment",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    event = "BufReadPre",
    opts = {
      options = {
        -- Delegate comment string detection to treesitter context so that
        -- Razor files use // inside @code blocks and <!-- --> in HTML sections.
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring()
            or vim.bo.commentstring
        end,
      },
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    -- enable_autocmd = false: mini.comment calls this manually; no autocmd needed
    opts = { enable_autocmd = false },
  },
}
