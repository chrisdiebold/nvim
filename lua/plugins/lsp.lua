-- Servers use lspconfig names. mason-lspconfig installs them; we enable them below.
local servers = {
  "basedpyright",
  "biome", -- only attaches when the project has biome.json
  "clangd",
  "docker_compose_language_service",
  "dockerls",
  "eslint", -- only attaches when the project has an eslint config
  "gopls",
  "jsonls",
  "lua_ls",
  "marksman",
  "ruff",
  "rust_analyzer",
  "taplo",
  "vtsls",
  "yamlls",
}

local function configure_servers()
  vim.lsp.config("gopls", {
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
        usePlaceholders = true,
        hints = { parameterNames = true, assignVariableTypes = true },
      },
    },
  })

  vim.lsp.config("basedpyright", {
    settings = { basedpyright = { analysis = { typeCheckingMode = "standard" } } },
  })

  vim.lsp.config("ruff", {
    on_attach = function(client)
      client.server_capabilities.hoverProvider = false -- leave hover to basedpyright
    end,
  })

  vim.lsp.config("jsonls", {
    settings = {
      json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } },
    },
  })

  vim.lsp.config("yamlls", {
    settings = {
      yaml = {
        schemaStore = { enable = false, url = "" },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  })

  vim.lsp.config("clangd", {
    cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
  })
end

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "b0o/SchemaStore.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
      configure_servers()

      require("mason").setup()
      -- Enable only our list, not every LSP that happens to be installed in Mason
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = false,
      })
      vim.lsp.enable(servers)

      -- Built-in defaults already cover: K, grn (rename), gra (code action), grr (references),
      -- gri (implementation), grt (type definition), gO (symbols), <C-s> (signature help)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = function(ev)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
          end, "Toggle inlay hints")
        end,
      })
    end,
  },

  -- Formatters and linters that aren't LSP servers (Mason package names)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "clang-format",
        "gofumpt",
        "goimports",
        "hadolint",
        "markdownlint-cli2",
        "prettierd",
        "sqlfluff",
        "stylua",
      },
    },
  },

  -- Neovim API completion and types when editing this config
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
    },
  },
}
