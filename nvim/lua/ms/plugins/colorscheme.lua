return {
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("tokyonight").setup({
                style = "moon",
                -- transparent = true,
            })
            -- Load the colorscheme here
            vim.cmd([[colorscheme tokyonight]])

            -- LSP janela flutuante
            vim.api.nvim_set_hl(0, "LspFloatWinNormal", {
                bg = "#292e42",
                fg = "#d4d8e5",
            })
            vim.api.nvim_set_hl(0, "LspFloatWinBorder", {
                fg = "#444b6a",
                bg = "#292e42",
            })
        end,
    }
}
