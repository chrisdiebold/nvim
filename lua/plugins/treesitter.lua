local parsers = {
  "bash", "c", "cpp", "css", "diff", "dockerfile", "go", "gomod", "gosum", "html",
  "javascript", "jsdoc", "json", "lua", "luadoc", "markdown", "markdown_inline", "python",
  "query", "regex", "rust", "sql", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(ev)
        if not pcall(vim.treesitter.start, ev.buf) then
          return
        end
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldlevel = 99
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
