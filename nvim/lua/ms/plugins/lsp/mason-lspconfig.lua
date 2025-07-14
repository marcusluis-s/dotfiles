return {
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate" },
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
                border = "rounded",
            },
            log_level = vim.log.levels.INFO,
            max_concurrent_installers = 4,
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp", -- For LSP completion capabilities
        },
        opts = {
            ensure_installed = {
                "lua_ls",
                "ts_ls",
                "clangd",
            }, -- Automatically install lua_ls
            automatic_enable = true, -- Auto-enable installed servers (Mason-LSPconfig 2.0+)
        },
        config = function(_, opts)
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")

            -- Setup Mason
            require("mason").setup(opts)

            -- LSP capabilities for nvim-cmp
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                cmp_nvim_lsp.default_capabilities()
            )

            -- On-attach function for keymaps
            local on_attach = function(client, bufnr)
                local opts = { buffer = bufnr, noremap = true, silent = true }
                -- Hover documentation keymap
                vim.keymap.set("n", "<K>", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show LSP hover documentation" }))
                -- Additional useful LSP keymaps
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
            end

            -- Diagnostic configuration
            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
                severity_sort = true,
            })

            -- Match nvim-cmp window borders for hover
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            })

            -- Setup Mason-LSPconfig
            mason_lspconfig.setup(opts)

            -- Configure LSP servers manually for custom settings
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } }, -- Recognize 'vim' global
                        workspace = { checkThirdParty = false },
                        hint = { enable = true }, -- Inline hints
                    },
                },
            })

            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                },
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
            })

            lspconfig.clangd.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { "clangd", "--background-index", "--clang-tidy" },
                filetypes = { "c", "cpp", "objc", "objcpp" },
            })
        end,
    },
}
