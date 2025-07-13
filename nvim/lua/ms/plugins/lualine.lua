return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")

        -- TokyoNight Moon theme colors with consistent naming
        local colors = {
            bg_dark = "#1f2335",      -- Main background
            bg_lighter = "#24283b",   -- Lighter background
            fg_light = "#c0caf5",     -- Main foreground
            blue = "#7aa2f7",         -- Blue accent
            cyan = "#7dcfff",         -- Cyan accent
            purple = "#9d7cd8",       -- Purple accent
            green = "#9ece6a",        -- Green accent
            orange = "#ff9e64",       -- Orange accent
            red = "#f7768e",          -- Red accent
        }

        local lualine_theme = {
            normal = {
                a = { fg = colors.bg_dark, bg = colors.blue, gui = "bold" },
                b = { fg = colors.fg_light, bg = colors.bg_lighter },
                c = { fg = colors.fg_light, bg = colors.bg_dark },
            },
            insert = {
                a = { fg = colors.bg_dark, bg = colors.green, gui = "bold" },
                b = { fg = colors.fg_light, bg = colors.bg_lighter },
                c = { fg = colors.fg_light, bg = colors.bg_dark },
            },
            visual = {
                a = { fg = colors.bg_dark, bg = colors.purple, gui = "bold" },
                b = { fg = colors.fg_light, bg = colors.bg_lighter },
                c = { fg = colors.fg_light, bg = colors.bg_dark },
            },
            replace = {
                a = { fg = colors.bg_dark, bg = colors.red, gui = "bold" },
                b = { fg = colors.fg_light, bg = colors.bg_lighter },
                c = { fg = colors.fg_light, bg = colors.bg_dark },
            },
            inactive = {
                a = { fg = colors.fg_light, bg = colors.bg_lighter, gui = "bold" },
                b = { fg = colors.fg_light, bg = colors.bg_lighter },
                c = { fg = colors.fg_light, bg = colors.bg_dark },
            },
        }

        -- Components
        local mode = {
            'mode',
            fmt = function(str)
                return ' ' .. str
            end,
            color = { gui = 'bold' },
        }

        local branch = {
            'branch',
            icon = { '', color = { fg = colors.cyan } },
            separator = '|',
        }

        local diff = {
            'diff',
            colored = true,
            symbols = { 
                added = ' ', 
                modified = ' ', 
                removed = ' ' 
            },
            source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed
                    }
                end
            end,
        }

        local diagnostics = {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = { 
                error = ' ', 
                warn = ' ', 
                info = ' ', 
                hint = ' ' 
            },
            diagnostics_color = {
                error = { fg = colors.red },
                warn = { fg = colors.orange },
                info = { fg = colors.cyan },
                hint = { fg = colors.green },
            },
        }

        local filename = {
            'filename',
            file_status = true,
            path = 0,
            symbols = {
                modified = '●',
                readonly = '[-]',
                unnamed = '[No Name]',
            },
        }

        local progress = {
            'progress',
            fmt = function() 
                return '%P/%L' 
            end,
            color = { fg = colors.cyan },
        }

        -- Custom fileformat component to show Apple logo on macOS
        local fileformat = {
            'fileformat',
            symbols = {
                unix = vim.fn.has('mac') == 1 and '' or '🐧',  -- Apple logo on macOS, penguin on Linux
                dos = '',                                      -- Windows icon
                mac = '',                                       -- Apple logo for classic mac format
            },
            color = { fg = colors.cyan },
        }

        lualine.setup({
            options = {
                theme = lualine_theme,
                component_separators = { left = '│', right = '│' },
                section_separators = { left = '', right = '' },
                globalstatus = true,  -- Single statusline for all windows
            },
            sections = {
                lualine_a = { mode },
                lualine_b = { branch, diff },
                lualine_c = { diagnostics, filename },
                lualine_x = {
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = colors.orange },
                    },
                    { 'filetype', icon_only = true, separator = '' },
                    { 'encoding', separator = '│' },
                    -- { 'fileformat', separator = '│' },
                    fileformat -- Updated fileformat
                },
                lualine_y = { progress },
                lualine_z = { 'location' },
            },
        })
    end,
}
