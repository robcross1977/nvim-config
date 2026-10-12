---nvim-lspconfig + mason: LSP server management and configuration (Neovim 0.12 `vim.lsp.config` API).
---mason auto-installs servers; mason-lspconfig auto-enables them via vim.lsp.enable().
---mason-tool-installer handles non-LSP tools (formatters, debug adapters).
---
---C# / Razor LSP is NOT configured here: easy-dotnet.nvim owns Roslyn (see easy-dotnet.lua).
---
---TypeScript strategy (only one TS server ever attaches to a project):
---  * TypeScript 7+ in the project (native Go compiler) → `tsc --lsp` (lspconfig `tsc`), 8-10x faster
---  * otherwise → vtsls (VS Code's TS extension, supports tsserver plugins like Next.js's)
---ESLint / Biome / Oxlint attach only when the project has their config file.
---
---Docs: https://github.com/neovim/nvim-lspconfig
---      https://github.com/mason-org/mason.nvim
---      https://github.com/mason-org/mason-lspconfig.nvim
---      https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
---      https://github.com/yioneko/vtsls
---      https://github.com/b0o/SchemaStore.nvim

---Project root → native TypeScript (7+) binary, filled in by the `tsc` root_dir below.
---@type table<string, string>
local native_ts_bins = {}

---Walks up from the buffer to the nearest node_modules that has TypeScript installed and
---returns that directory plus its native compiler binary, if it is TypeScript 7+ (or tsgo).
---@param bufnr integer
---@return string? root, string? bin
local function find_native_ts(bufnr)
  for dir in vim.fs.parents(vim.api.nvim_buf_get_name(bufnr)) do
    local bin_dir = vim.fs.joinpath(dir, "node_modules", ".bin")
    local pkg = vim.fs.joinpath(dir, "node_modules", "typescript", "package.json")
    local tsgo = vim.fs.joinpath(bin_dir, "tsgo") -- @typescript/native-preview
    if vim.uv.fs_stat(pkg) then
      local ok, json = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), "\n"))
      local version = ok and vim.version.parse(json.version or "") or nil
      if version and version.major >= 7 then
        return dir, vim.fs.joinpath(bin_dir, "tsc")
      end
      if vim.uv.fs_stat(tsgo) then
        return dir, tsgo
      end
      return nil -- TypeScript < 7
    elseif vim.uv.fs_stat(tsgo) then
      return dir, tsgo
    end
  end
end

---Run a TS "source action" (organize imports, add missing imports, …) on the current buffer.
---@param action string
---@return function
local function ts_source_action(action)
  return function()
    vim.lsp.buf.code_action({ apply = true, context = { only = { action }, diagnostics = {} } })
  end
end

local ts_inlay_hints = {
  enumMemberValues = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  parameterNames = { enabled = "literals" },
  parameterTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  variableTypes = { enabled = false },
}

return {
  { "b0o/SchemaStore.nvim", lazy = true, version = false },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    opts = {},
  },
  {
    -- Auto-install non-LSP Mason tools: formatters, debug adapters
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "csharpier",         -- C# / XML formatter (conform.nvim)
        "prettier",          -- JS/TS/CSS/JSON/MD formatter fallback (conform.nvim)
        "js-debug-adapter",  -- vscode-js-debug for Node / Next.js / Chrome (nvim-dap)
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "b0o/SchemaStore.nvim",
      "saghen/blink.cmp", -- registers its completion capabilities via vim.lsp.config("*")
    },
    ---@return nil
    config = function()
      -- ── Server overrides (merged on top of nvim-lspconfig's lsp/*.lua defaults) ──
      vim.lsp.config("vtsls", {
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true, -- use the project's TypeScript (and its tsconfig plugins, e.g. Next.js)
            experimental = {
              maxInlayHintLength = 30,
              completion = { enableServerSideFuzzyMatch = true },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            inlayHints = ts_inlay_hints,
            tsserver = { maxTsServerMemory = 8192 },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = ts_inlay_hints,
          },
        },
      })

      vim.lsp.config("eslint", {
        settings = {
          workingDirectories = { mode = "auto" }, -- monorepo-friendly
        },
      })

      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(), -- package.json, tsconfig, app.json (Expo), eas.json, …
            validate = { enable = true },
          },
        },
      })

      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" }, -- use SchemaStore.nvim instead of the built-in fetcher
            schemas = require("schemastore").yaml.schemas(), -- GitHub Actions, docker-compose, …
          },
        },
      })

      vim.lsp.config("tailwindcss", {
        settings = {
          tailwindCSS = {
            -- className helpers common in React/Next/RN (NativeWind) codebases
            classFunctions = { "cn", "clsx", "cva", "tw", "twMerge" },
          },
        },
      })

      vim.lsp.config("emmet_language_server", {
        filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact", "razor" },
      })

      -- One TS server per project: native `tsc --lsp` for TS 7+, vtsls for everything else.
      local vtsls_root = vim.lsp.config.vtsls.root_dir
      vim.lsp.config("vtsls", {
        root_dir = function(bufnr, on_dir)
          if not find_native_ts(bufnr) then
            vtsls_root(bufnr, on_dir)
          end
        end,
      })
      vim.lsp.config("tsc", {
        cmd = function(dispatchers, config)
          return vim.lsp.rpc.start({ native_ts_bins[config.root_dir], "--lsp", "--stdio" }, dispatchers)
        end,
        root_dir = function(bufnr, on_dir)
          local root, bin = find_native_ts(bufnr)
          if root and bin then
            native_ts_bins[root] = bin
            on_dir(root)
          end
        end,
      })

      -- ── Install + enable ──────────────────────────────────────────────────
      require("mason-lspconfig").setup({
        ensure_installed = {
          "vtsls",                 -- TypeScript / JavaScript (TS < 7)
          "eslint",                -- ESLint diagnostics + fixes (vscode-eslint-language-server)
          "biome",                 -- Biome lint/format (only attaches with biome.json)
          "tailwindcss",           -- Tailwind / NativeWind class completion + hover
          "cssls",                 -- CSS / SCSS / CSS Modules
          "html",                  -- HTML (also used by easy-dotnet for Razor markup)
          "jsonls",                -- JSON + SchemaStore
          "yamlls",                -- YAML + SchemaStore
          "emmet_language_server", -- Emmet abbreviations in HTML/JSX
          "hls",                   -- Haskell
        },
        automatic_enable = {
          -- ts_ls is superseded by vtsls; roslyn is managed by easy-dotnet.
          exclude = { "ts_ls", "roslyn", "roslyn_ls", "csharp_ls", "omnisharp" },
        },
      })
      -- Not installed via Mason: these resolve from the project (node_modules/.bin) and
      -- only attach when the project actually uses them.
      vim.lsp.enable({ "tsc", "oxlint" })

      -- ── Keymaps on attach ────────────────────────────────────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          ---@param mode string|string[]
          ---@param lhs string
          ---@param rhs string|function
          ---@param desc string
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, nowait = true })
          end

          map("n", "K", vim.lsp.buf.hover, "Hover docs")
          map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gi", function() Snacks.picker.lsp_implementations() end, "Go to implementation")
          map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, "Go to type definition")
          map("n", "gr", function() Snacks.picker.lsp_references() end, "References")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code actions")
          map("n", "<leader>cR", function() Snacks.rename.rename_file() end, "Rename file (updates imports)")
          map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, "Document symbols")
          map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")
          map("n", "<leader>k", vim.lsp.buf.signature_help, "Signature help")
          map("n", "gl", vim.diagnostic.open_float, "Line diagnostics")
          map("n", "<leader>uh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
          end, "Toggle inlay hints")

          if client and (client.name == "vtsls" or client.name == "tsc") then
            map("n", "<leader>co", ts_source_action("source.organizeImports"), "Organize imports")
            map("n", "<leader>cM", ts_source_action("source.addMissingImports.ts"), "Add missing imports")
            map("n", "<leader>cu", ts_source_action("source.removeUnused.ts"), "Remove unused imports")
            map("n", "<leader>cD", ts_source_action("source.fixAll.ts"), "Fix all diagnostics")
          end
          if client and client.name == "vtsls" then
            map("n", "gR", function()
              client:exec_cmd({ command = "typescript.findAllFileReferences", arguments = { vim.uri_from_bufnr(buf) } })
            end, "File references")
            map("n", "<leader>cV", function()
              client:exec_cmd({ command = "typescript.selectTypeScriptVersion" })
            end, "Select TS workspace version")
          end
          if client and client.name == "eslint" then
            map("n", "<leader>cE", "<cmd>LspEslintFixAll<cr>", "ESLint: fix all")
          end
        end,
      })
    end,
  },
}
