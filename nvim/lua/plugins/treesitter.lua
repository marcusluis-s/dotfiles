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
                "diff",
            },
            -- Autoinstall parsers that are not installed
            auto_install = true,
            autopairs = {
                enable = true,
            },
            autotag = {
                enable = false,
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
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
        }
    end
}
