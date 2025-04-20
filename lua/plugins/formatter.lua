return { -- Autoformat
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end
      end,
      formatters_by_ft = {
        c = { name = "clangd", timeout_ms = 500, lsp_format = "prefer" },
        javascript = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        javascriptreact = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        json = { "prettier", stop_on_first = true, name = "dprint", timeout_ms = 500 },
        jsonc = { "prettier", stop_on_first = true, name = "dprint", timeout_ms = 500 },
        less = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "isort", "black" },
        rust = { name = "rust_analyzer", timeout_ms = 500, lsp_format = "prefer" },
        scss = { "prettier" },
        sh = { "shfmt" },
        typescript = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        typescriptreact = { "prettier", name = "dprint", timeout_ms = 500, lsp_format = "fallback" },
        -- For filetypes without a formatter:
        ["_"] = { "trim_whitespace", "trim_newlines" },
      },
      format_on_save = function()
        -- Don't format when minifiles is open, since that triggers the "confirm without
        -- synchronization" message.
        if vim.g.minifiles_active then
          return nil
        end

        -- Stop if we disabled auto-formatting.
        if not vim.g.autoformat then
          return nil
        end

        return {}
      end,
    },
    init = function()
      -- Use conform for gq.
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      -- Start auto-formatting by default (and disable with my ToggleFormat command).
      vim.g.autoformat = true
    end,
  },
}
