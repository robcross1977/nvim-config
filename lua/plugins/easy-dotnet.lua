---easy-dotnet.nvim: self-contained .NET tooling for Neovim.
---  * Roslyn LSP (official `roslyn-language-server` dotnet tool, auto-installed if missing)
---  * Razor/CSHTML via Roslyn cohosting + vscode-html-language-server (Mason `html-lsp`)
---  * ProjX LSP: NuGet package completion inside .csproj/.fsproj (replaces the old blink source)
---  * Bundled debugger (netcoredbg / dncdbg / sharpdbg) wired into nvim-dap
---  * Test runner + neotest adapter, workspace diagnostics, outdated packages, EF Core, secrets
---Requires the server tool: `dotnet tool install -g EasyDotnet` (update with `dotnet tool update -g EasyDotnet`).
---Docs: https://github.com/GustavEikaas/easy-dotnet.nvim
-- .csproj/.fsproj/.slnx/.props are detected as "xml"; .sln as "solution".
local dotnet_fts = { "cs", "fs", "vb", "razor", "cshtml", "xml", "solution" }

---@param cmd string
---@return function
local function dotnet_cmd(cmd)
  return function()
    vim.cmd("Dotnet " .. cmd)
  end
end

return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    "folke/snacks.nvim",
  },
  ft = { "cs", "fs", "vb", "razor", "cshtml", "solution" },
  cmd = { "Dotnet", "Secrets" },
  keys = {
    { "<C-p>", dotnet_cmd("run default"), desc = "Dotnet: run default project", ft = dotnet_fts },
    { "<leader>nr", dotnet_cmd("run"), desc = "Run project", ft = dotnet_fts },
    { "<leader>nR", dotnet_cmd("run profile"), desc = "Run with launch profile", ft = dotnet_fts },
    { "<leader>nw", dotnet_cmd("watch"), desc = "Watch (hot reload)", ft = dotnet_fts },
    { "<leader>nd", dotnet_cmd("debug"), desc = "Debug project", ft = dotnet_fts },
    { "<leader>nD", dotnet_cmd("debug attach"), desc = "Attach debugger", ft = dotnet_fts },
    { "<leader>nb", dotnet_cmd("build quickfix"), desc = "Build project → quickfix", ft = dotnet_fts },
    { "<leader>nB", dotnet_cmd("build solution quickfix"), desc = "Build solution → quickfix", ft = dotnet_fts },
    { "<leader>nt", dotnet_cmd("testrunner"), desc = "Test runner", ft = dotnet_fts },
    { "<leader>nT", dotnet_cmd("test solution"), desc = "Test solution", ft = dotnet_fts },
    { "<leader>ne", dotnet_cmd("diagnostic errors"), desc = "Workspace errors", ft = dotnet_fts },
    { "<leader>nE", dotnet_cmd("diagnostic warnings"), desc = "Workspace warnings", ft = dotnet_fts },
    { "<leader>na", dotnet_cmd("add package"), desc = "Add NuGet package", ft = dotnet_fts },
    { "<leader>no", dotnet_cmd("outdated"), desc = "Outdated packages", ft = dotnet_fts },
    { "<leader>nn", dotnet_cmd("new"), desc = "New from template", ft = dotnet_fts },
    { "<leader>ns", dotnet_cmd("solution select"), desc = "Select solution", ft = dotnet_fts },
    { "<leader>nx", dotnet_cmd("restore"), desc = "Restore", ft = dotnet_fts },
    { "<leader>nc", dotnet_cmd("clean"), desc = "Clean", ft = dotnet_fts },
    { "<leader>nS", function() require("easy-dotnet").secrets() end, desc = "User secrets", ft = dotnet_fts },
  },
  ---@return nil
  config = function()
    local dotnet = require("easy-dotnet")
    local is_windows = require("easy-dotnet.extensions").isWindows() == true

    dotnet.setup({
      lsp = {
        enabled = true,
        roslynator_enabled = true,
        easy_dotnet_analyzer_enabled = true,
        easy_dotnet_extension_enabled = true, -- needed for enhanced_rename + create_type_from_usage
        enhanced_rename = true, -- renaming a class also renames its file
        create_type_from_usage = true, -- code action: generate a class from an unresolved symbol
        restart_roslyn_on_branch_change = true, -- avoid stale diagnostics after `git switch`
        razor = { enabled = true },
      },
      debugger = {
        engine = "netcoredbg", -- or "dncdbg" (richer netcoredbg fork) / "sharpdbg" (C# debugger)
        auto_register_dap = true,
        apply_value_converters = true,
        mappings = {
          open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
        },
      },
      test_runner = {
        viewmode = "float",
        -- neotest drives buffer signs/keymaps so .NET and JS/TS tests share the same <leader>T keys.
        -- The Rider-style runner is still available via <leader>nt / :Dotnet testrunner.
        neotest_integration = true,
      },
      auto_bootstrap_namespace = {
        type = "file_scoped",
        enabled = true,
      },
      picker = "snacks",
      server = { use_visual_studio = is_windows },
    })

    vim.api.nvim_create_user_command("Secrets", function()
      dotnet.secrets()
    end, {})
  end,
}
