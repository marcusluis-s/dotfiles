-- vim.g.mapleader = " " -- Define <leader> como espaço

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- Para capacidades de autocompletar
            "williamboman/mason.nvim", -- Dependência para garantir que o Mason esteja carregado
        },
        config = function()
            -- Configurações globais de diagnósticos
            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
                severity_sort = true,
            })

            -- Configuração do handler para textDocument/hover
            vim.api.nvim_set_hl(0, "LspFloatWinNormal", { bg = "#2a2a2a", fg = "#ffffff" })
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                max_width = math.floor(vim.o.columns * 0.6),
                max_height = 20,
                focusable = true,
                highlight = "LspFloatWinNormal",
            })

            -- Função on_attach para mapeamentos
            local on_attach = function(client, bufnr)
                local opts_keymaps = { buffer = bufnr, noremap = true, silent = true }

                -- Hover documentation keymap
                vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, vim.tbl_extend("force", opts_keymaps, { desc = "Show LSP hover documentation" }))

                -- Mapeamentos de teclas comuns
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts_keymaps, { desc = "Go to definition" }))
                vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts_keymaps, { desc = "Find references" }))
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts_keymaps, { desc = "Code action" }))
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts_keymaps, { desc = "Rename symbol" }))
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts_keymaps, { desc = "Show diagnostics" }))
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts_keymaps, { desc = "Previous diagnostic" }))
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts_keymaps, { desc = "Next diagnostic" }))

                -- Não aplicar formatters no on_attach
                -- if client.server_capabilities.documentFormattingProvider then
                --   vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts_keymaps)
                -- end
            end

            -- Capacidades de autocompletar
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )

            -- Configuração dos servidores LSP
            local lspconfig = require("lspconfig")

            -- Lua
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                        hint = { enable = true },
                    },
                },
            })

            -- JavaScript, TypeScript, React
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

            -- Go
            --[[ lspconfig.gopls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                },
            }) ]]

            -- Java
            --[[ lspconfig.jdtls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    java = {
                        signatureHelp = { enabled = true },
                        completion = {
                            favoriteStaticMembers = {
                                "org.junit.Assert.*",
                                "org.junit.Assume.*",
                                "java.util.Objects.requireNonNull",
                                "java.util.Objects.requireNonNullElse",
                            },
                        },
                        sources = {
                            organizeImports = {
                                starThreshold = 9999,
                                staticStarThreshold = 9999,
                            },
                        },
                    },
                },
            }) ]]

            -- C, C++
            lspconfig.clangd.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { "clangd", "--background-index", "--clang-tidy" },
                filetypes = { "c", "cpp", "objc", "objcpp" },
            })
        end,
    },
}
