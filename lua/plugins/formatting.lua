-- biome-check only runs in projects with a biome config; otherwise prettier is used
local web = { "biome-check", "prettierd", stop_after_first = true }

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "Format",
    },
    {
      "<leader>uf",
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
      end,
      desc = "Toggle format on save",
    },
  },
  opts = {
    formatters_by_ft = {
      c = { "clang-format" },
      cpp = { "clang-format" },
      css = { "prettierd" },
      go = { "goimports", "gofumpt" },
      html = { "prettierd" },
      javascript = web,
      javascriptreact = web,
      json = web,
      jsonc = web,
      lua = { "stylua" },
      python = { "ruff_organize_imports", "ruff_format" },
      rust = { "rustfmt" },
      sql = { "sqlfluff" },
      typescript = web,
      typescriptreact = web,
      yaml = { "prettierd" },
      -- toml and anything else fall back to the LSP formatter (taplo)
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function()
      if vim.g.disable_autoformat then
        return
      end
      return { timeout_ms = 1000 }
    end,
    formatters = {
      ["biome-check"] = { require_cwd = true },
      sqlfluff = { require_cwd = true }, -- needs a .sqlfluff to know the dialect
    },
  },
}
