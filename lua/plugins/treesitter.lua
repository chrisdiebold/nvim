return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = {
                "bash",
                "c", "cpp",
                "comment",
                "css",
                "diff",
                "dockerfile",
                "go", "gomod", "gosum",
                "groovy",
                "html",
                "java", "javadoc",
                "javascript", "json",
                "lua",
                "markdown",
                "python",
                "rust",
                "toml",
                "typescript",
                "vim", "vimdoc",
            },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            
            additional_vim_regex_highlighting = false,

        })
    end
}
