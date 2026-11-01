-- Most languages lint through their LSP (eslint, ruff, gopls, clangd, ...).
-- nvim-lint covers the ones without a good server.
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      dockerfile = { "hadolint" },
      markdown = { "markdownlint-cli2" },
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
