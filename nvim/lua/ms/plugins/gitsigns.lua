return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Lazy load on buffer events
    dependencies = {
        "nvim-lua/plenary.nvim", -- Required by gitsigns
    },
    config = function()
        local gitsigns = require("gitsigns")

        -- TokyoNight Moon theme colors (matching your lualine setup)
        local colors = {
            green = "#9ece6a",   -- For added lines
            orange = "#ff9e64",  -- For changed lines
            red = "#f7768e",     -- For removed lines
            cyan = "#7dcfff",    -- For blame text
        }

        gitsigns.setup({
            signs = {
                add = { text = "│", hl = "GitSignsAdd", numhl = "GitSignsAddNr" },
                change = { text = "│", hl = "GitSignsChange", numhl = "GitSignsChangeNr" },
                delete = { text = "│", hl = "GitSignsDelete", numhl = "GitSignsDeleteNr" },
                topdelete = { text = "‾", hl = "GitSignsDelete", numhl = "GitSignsDeleteNr" },
                changedelete = { text = "~", hl = "GitSignsChange", numhl = "GitSignsChangeNr" },
                untracked = { text = "┆", hl = "GitSignsAdd", numhl = "GitSignsAddNr" },
            },
            signcolumn = true,  -- Show signs in the sign column
            numhl = false,      -- Disable number highlighting (can enable if preferred)
            linehl = false,     -- Disable full-line highlighting
            word_diff = false,  -- Disable inline word diff
            watch_gitdir = {
                interval = 1000, -- Check for git changes every 1 second
                follow_files = true,
            },
            attach_to_untracked = true, -- Show signs for untracked files
            --[[ current_line_blame = true,  -- Show blame info for the current line
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol", -- Place blame at end of line
                delay = 300,           -- Delay before showing blame (ms)
                ignore_whitespace = false,
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>', ]]
            sign_priority = 6, -- Priority for signs to avoid conflicts
            update_debounce = 100, -- Debounce time for updates (ms)
            status_formatter = nil, -- Use default status line format
            max_file_length = 40000, -- Disable for very large files
            preview_config = {
                border = "rounded", -- Rounded borders for preview windows
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            -- Highlight groups for consistent theming
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                -- Keymappings
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then return "]c" end
                    vim.schedule(function() gs.next_hunk() end)
                    return "<Ignore>"
                end, { expr = true, desc = "Next git hunk" })

                map("n", "[c", function()
                    if vim.wo.diff then return "[c" end
                    vim.schedule(function() gs.prev_hunk() end)
                    return "<Ignore>"
                end, { expr = true, desc = "Previous git hunk" })

                -- Actions
                map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
                map("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Stage selected hunk" })
                map("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end, { desc = "Reset selected hunk" })
                map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
                map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
                map("n", "<leader>hb", function() gs.blame_line { full = true } end, { desc = "Blame line" })
                map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
                map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
                map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff against last commit" })
                map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted lines" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select git hunk" })

                -- Define highlight groups for gitsigns to match tokyonight-moon
                vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colors.green })
                vim.api.nvim_set_hl(0, "GitSignsChange", { fg = colors.orange })
                vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colors.red })
                vim.api.nvim_set_hl(0, "GitSignsAddNr", { fg = colors.green })
                vim.api.nvim_set_hl(0, "GitSignsChangeNr", { fg = colors.orange })
                vim.api.nvim_set_hl(0, "GitSignsDeleteNr", { fg = colors.red })
                vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = colors.cyan, italic = true })
            end,
        })
    end,
}
