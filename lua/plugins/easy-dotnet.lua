---easy-dotnet.nvim: self-contained .NET tooling for Neovim (Roslyn LSP, build/test/run, debugging).
---Docs: https://github.com/GustavEikaas/easy-dotnet.nvim?tab=readme-ov-file
return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    "folke/snacks.nvim",
    "saghen/blink.cmp",
  },
  ft = { "cs", "fs", "vb", "razor", "cshtml" },
  cmd = { "Dotnet" },
  ---@return nil
  config = function()
    local dotnet = require("easy-dotnet")
    local is_windows = require("easy-dotnet.extensions").isWindows() == true

    dotnet.setup({
      lsp = {
        enabled = true,
        roslynator_enabled = true,
        easy_dotnet_analyzer_enabled = true,
      },
      debugger = {
        auto_register_dap = true,
        apply_value_converters = true,
        mappings = {
          open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
        },
      },
      ---@param path string
      ---@param action "test" | "restore" | "build" | "run" | "watch"
      ---@param args? string
      ---@return nil
      terminal = function(path, action, args)
        local template_by_action = {
          run = "dotnet run --project %s %s",
          test = "dotnet test %s %s",
          restore = "dotnet restore %s %s",
          build = "dotnet build %s %s",
          watch = "dotnet watch --project %s %s",
        }

        local template = template_by_action[action]
        if template == nil then
          return
        end

        local command = string.format(template, path, args or "")
        if is_windows then
          command = command .. "\r"
        end

        vim.cmd("vsplit")
        vim.cmd("term " .. command)
      end,
      picker = "snacks",
      background_scanning = true,
      test_runner = {
        viewmode = "float",
        enable_buffer_test_execution = true,
        noBuild = true,
      },
      server = { use_visual_studio = is_windows },
    })

    vim.api.nvim_create_user_command("Secrets", function()
      dotnet.secrets()
    end, {})

    vim.keymap.set("n", "<C-p>", function()
      dotnet.run_project()
    end, { desc = "Dotnet: run project" })
  end,
}

