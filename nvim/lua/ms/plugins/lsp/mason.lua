-- lua/ms/plugins/lsp/mason.lua
return {
    {
        "williamboman/mason.nvim",
        lazy = false, -- Carrega imediatamente
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
        config = function(_, opts)
            require("mason").setup(opts)
            -- Lista de servidores a serem instalados
            local servers = {
                "lua-language-server", -- Lua
                "typescript-language-server", -- JavaScript, TypeScript, React
                -- "gopls", -- Go
                -- "jdtls", -- Java
                "clangd", -- C, C++
            }
            -- Instala servidores que não estão instalados
            local mason_registry = require("mason-registry")
            for _, server in ipairs(servers) do
                local pkg = mason_registry.get_package(server)
                if not pkg:is_installed() then
                    print("Installing " .. server) -- Debug
                    pkg:install()
                end
            end
        end,
    },
}
