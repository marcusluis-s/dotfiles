return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = {
                "lua",
                "luadoc",
                "bash",
                "c",
                "cmake",
                "make",
                "html",
                "css",
                "scss",
                "markdown",
                "markdown_inline",
                "vim",
                "vimdoc",
                "query",
                "dockerfile",
                "gitignore",
                "javascript",
                "jsdoc",
                "typescript",
                "tsx",
                "python",
            },
            auto_install = true,
            autopairs = {
                enable = true,
            },
            autotag = {
                enable = true,
            },
            endwise = {
                enable = true,
            },
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        }
    end
}
