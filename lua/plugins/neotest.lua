---neotest: one test UI for every language, so the same <leader>T keys work everywhere.
---  * .NET: easy-dotnet's built-in adapter (shares state with :Dotnet testrunner)
---  * Vitest (Next.js / Vite / React) and Jest (React Native / Expo / older Next.js)
---Docs: https://github.com/nvim-neotest/neotest
---      https://github.com/marilari88/neotest-vitest
---      https://github.com/nvim-neotest/neotest-jest
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "GustavEikaas/easy-dotnet.nvim",
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-jest",
  },
  keys = {
    { "<leader>Tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
    { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file" },
    { "<leader>TA", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run all (cwd)" },
    { "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Run last" },
    { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
    { "<leader>Tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Watch file" },
    { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Summary" },
    { "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Output" },
    { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Output panel" },
    { "<leader>TS", function() require("neotest").run.stop() end, desc = "Stop" },
    { "]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next failed test" },
    { "[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Prev failed test" },
  },
  ---@return nil
  config = function()
    require("neotest").setup({
      adapters = {
        require("easy-dotnet.neotest"),
        require("neotest-vitest"),
        require("neotest-jest")({
          jestCommand = "npx jest",
          cwd = function(path)
            -- run from the nearest package.json so monorepo packages use their own jest config
            return vim.fs.root(path, "package.json") or vim.uv.cwd()
          end,
        }),
      },
      status = { virtual_text = true },
      output = { open_on_run = false },
    })
  end,
}
