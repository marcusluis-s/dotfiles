-- Function to show diagnostics in a floating window with custom options
function _G.open_diagnostics_float()
    vim.diagnostic.open_float(nil, {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        prefix = "",
        scope = "line",
    })
end

return {
    "neovim/nvim-lspconfig",

    config = function()
        local lspconfig = require("lspconfig")
        local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
        
        -- Servers
        lspconfig.clangd.setup({
            capabilities = lsp_capabilities
        })

        lspconfig.tsserver.setup({
            capabilities = lsp_capabilities
        })

        lspconfig.cssls.setup({
            capabilities = lsp_capabilities
        })

        -- Key mappings for diagnostics
        local opts = { noremap=true, silent=true } 

        -- Show diagnostics in a floating window
        vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua open_diagnostics_float()<CR>", opts)

        -- Navigate to the previous diagnostic
        vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)

        -- Navigate to the next diagnostic
        vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

        -- Key mappings for LSP functionality
        vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        vim.api.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        vim.api.nvim_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
        vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    end
}
