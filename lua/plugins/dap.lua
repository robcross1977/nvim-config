---nvim-dap: Debug Adapter Protocol client.
---  * .NET: adapter + launch configs are registered by easy-dotnet.nvim (auto_register_dap)
---  * JS/TS/React/Next.js: vscode-js-debug (Mason `js-debug-adapter`), configs below
---  * A project's .vscode/launch.json is picked up automatically by nvim-dap
---nvim-dap-ui: variables/stack/breakpoints/console panels (also hosts easy-dotnet's CPU/MEM widgets).
---nvim-dap-virtual-text: inline variable values while stepping.
---Docs: https://github.com/mfussenegger/nvim-dap
---      https://github.com/rcarriga/nvim-dap-ui
---      https://github.com/microsoft/vscode-js-debug
local js_fts = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

---Register vscode-js-debug adapters (pwa-node, pwa-chrome, …) plus `node`/`chrome` aliases
---so launch.json files written for VS Code work unchanged.
---@param dap table
---@return nil
local function setup_js(dap)
  for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }) do
    dap.adapters[adapter] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = { command = "js-debug-adapter", args = { "${port}" } },
    }
  end
  for alias, target in pairs({ node = "pwa-node", chrome = "pwa-chrome" }) do
    dap.adapters[alias] = function(cb, config)
      if config.type == alias then
        config.type = target
      end
      cb(dap.adapters[target])
    end
  end

  local configs = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Node: launch current file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Node: attach to process",
      processId = function() return require("dap.utils").pick_process({ filter = "node" }) end,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Node: attach to :9229 (next dev --inspect, RN/Metro scripts)",
      port = 9229,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Next.js: debug server-side (next dev)",
      program = "${workspaceFolder}/node_modules/next/dist/bin/next",
      args = { "dev" },
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      console = "integratedTerminal",
      skipFiles = { "<node_internals>/**" },
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Chrome: debug client-side (localhost:3000)",
      url = function()
        local url = vim.fn.input("URL: ", "http://localhost:3000")
        return url ~= "" and url or "http://localhost:3000"
      end,
      webRoot = "${workspaceFolder}",
      sourceMaps = true,
      userDataDir = false,
    },
  }
  for _, ft in ipairs(js_fts) do
    dap.configurations[ft] = configs
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: start/continue" },
      { "<S-F5>", function() require("dap").terminate() end, desc = "Debug: stop" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
        desc = "Conditional breakpoint",
      },
      {
        "<leader>dl",
        function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end,
        desc = "Logpoint",
      },
      { "<leader>dc", function() require("dap").continue() end, desc = "Start/continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>dL", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dX", function() require("dap").clear_breakpoints() end, desc = "Clear breakpoints" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dk", function() require("dap").up() end, desc = "Stack frame up" },
      { "<leader>dj", function() require("dap").down() end, desc = "Stack frame down" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval expression", mode = { "n", "x" } },
    },
    ---@return nil
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "Visual" })

      dapui.setup()
      dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

      setup_js(dap)
    end,
  },
}
