return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown" },
    opts = {
        -- Enable/disable plugin
        enabled = true,
        -- Render modes: 'normal' for full rendering, 'virtual' for virtual text only
        render_modes = { "normal", "virtual" },
        -- Heading styles with tokyonight-moon colors
        heading = {
            enabled = true,
            icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
            signs = { "󰌕" },
            backgrounds = {
                "RenderMarkdownH1Bg",
                "RenderMarkdownH2Bg",
                "RenderMarkdownH3Bg",
                "RenderMarkdownH4Bg",
                "RenderMarkdownH5Bg",
                "RenderMarkdownH6Bg",
            },
            foregrounds = {
                "RenderMarkdownH1",
                "RenderMarkdownH2",
                "RenderMarkdownH3",
                "RenderMarkdownH4",
                "RenderMarkdownH5",
                "RenderMarkdownH6",
            },
        },
        -- Code block styling
        code = {
            enabled = true,
            sign = true,
            style = "full", -- Full block with language and borders
            left_pad = 2,
            right_pad = 2,
            min_width = 50,
            language_pad = 4,
            border = "thin",
        },
        -- Bullet list styling
        bullet = {
            enabled = true,
            icons = { "•", "◦", "▪", "▫" },
            left_pad = 0,
            right_pad = 1,
        },
        -- Checkbox styling
        checkbox = {
            enabled = true,
            unchecked = { icon = "󰄱 " },
            checked = { icon = "󰄲 " },
            custom = {
                in_progress = { raw = "[-]", icon = "󰄴 ", highlight = "RenderMarkdownTodo" },
            },
        },
        -- Table styling
        table = {
            enabled = true,
            left_pad = 1,
            right_pad = 1,
        },
        -- Quote styling
        quote = {
            enabled = true,
            icon = "│",
        },
        -- Custom highlights to match tokyonight-moon
        highlights = {
            heading = {
                backgrounds = {
                    ["RenderMarkdownH1Bg"] = "#3b4261",
                    ["RenderMarkdownH2Bg"] = "#3b4261",
                    ["RenderMarkdownH3Bg"] = "#3b4261",
                    ["RenderMarkdownH4Bg"] = "#3b4261",
                    ["RenderMarkdownH5Bg"] = "#3b4261",
                    ["RenderMarkdownH6Bg"] = "#3b4261",
                },
                foregrounds = {
                    ["RenderMarkdownH1"] = "#7aa2f7", -- Blue
                    ["RenderMarkdownH2"] = "#7dcfff", -- Cyan
                    ["RenderMarkdownH3"] = "#9d7cd8", -- Purple
                    ["RenderMarkdownH4"] = "#ff9e64", -- Orange
                    ["RenderMarkdownH5"] = "#9ece6a", -- Green
                    ["RenderMarkdownH6"] = "#c0caf5", -- Light foreground
                },
            },
            code = { "RenderMarkdownCode" },
            bullet = { "RenderMarkdownBullet" },
            checkbox = {
                unchecked = "RenderMarkdownUnchecked",
                checked = "RenderMarkdownChecked",
                custom = { in_progress = "RenderMarkdownTodo" },
            },
            table_border = "RenderMarkdownTableBorder",
            quote = "RenderMarkdownQuote",
        },
    },
    config = function(_, opts)
        local render_markdown = require("render-markdown")

        -- Setup plugin with options
        render_markdown.setup(opts)

        -- Define custom highlights to match tokyonight-moon
        local highlights = {
            RenderMarkdownCode = { bg = "#24283b" }, -- Lighter background
            RenderMarkdownBullet = { fg = "#7aa2f7" }, -- Blue
            RenderMarkdownUnchecked = { fg = "#ff9e64" }, -- Orange
            RenderMarkdownChecked = { fg = "#9ece6a" }, -- Green
            RenderMarkdownTodo = { fg = "#9d7cd8" }, -- Purple
            RenderMarkdownTableBorder = { fg = "#7dcfff" }, -- Cyan
            RenderMarkdownQuote = { fg = "#c0caf5" }, -- Light foreground
        }
        for group, style in pairs(highlights) do
            vim.api.nvim_set_hl(0, group, style)
        end

        -- Keymap to toggle rendering
        vim.keymap.set("n", "<leader>md", function()
            if render_markdown.state.enabled then
                render_markdown.disable()
            else
                render_markdown.enable()
            end
        end, { desc = "Toggle Markdown rendering" })
    end,
}
