return {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    branch = "main",
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
        },
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "nvim-treesitter/nvim-treesitter",
        "onsails/lspkind.nvim",
    },
    config = function()
        local cmp = require("cmp")
        local has_luasnip, luasnip = pcall(require, "luasnip")
        local lspkind = require("lspkind")

        -- Load friendly-snippets
        if has_luasnip then
            require("luasnip.loaders.from_vscode").lazy_load()
        end

        -- TokyoNight Moon theme colors
        local colors = {
            blue = "#7aa2f7",
            cyan = "#7dcfff",
            purple = "#9d7cd8",
            orange = "#ff9e64",
            green = "#9ece6a",
            fg_light = "#c0caf5",
            bg_lighter = "#24283b",
        }

        -- Helper functions
        local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local feedkey = function(key, mode)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
        end

        local toggle_completion = function()
            if cmp.visible() then
                cmp.close()
            else
                cmp.complete()
            end
        end

        -- Smart tab/backspace helpers
        local column = function()
            local _, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col
        end

        local in_snippet = function()
            if not has_luasnip then return false end
            local session = require("luasnip.session")
            local node = session.current_nodes[vim.api.nvim_get_current_buf()]
            if not node then return false end
            local snippet = node.parent.snippet
            local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end()
            local pos = vim.api.nvim_win_get_cursor(0)
            return pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1]
        end

        local in_whitespace = function()
            local col = column()
            return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%s")
        end

        local in_leading_indent = function()
            local col = column()
            local line = vim.api.nvim_get_current_line()
            local prefix = line:sub(1, col)
            return prefix:find("^%s*$")
        end

        local shift_width = function()
            return vim.o.softtabstop <= 0 and vim.fn.shiftwidth() or vim.o.softtabstop
        end

        local smart_bs = function(dedent)
            local keys
            if vim.o.expandtab then
                keys = dedent and "<C-D>" or "<BS>"
            else
                local col = column()
                local line = vim.api.nvim_get_current_line()
                local prefix = line:sub(1, col)
                if in_leading_indent() then
                    keys = "<BS>"
                else
                    local previous_char = prefix:sub(#prefix, #prefix)
                    if previous_char ~= " " then
                        keys = "<BS>"
                    else
                        keys = "<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>"
                    end
                end
            end
            feedkey(keys, "nt")
        end

        local smart_tab = function()
            local keys
            if vim.o.expandtab then
                keys = "<Tab>"
            else
                local col = column()
                local line = vim.api.nvim_get_current_line()
                local prefix = line:sub(1, col)
                if prefix:find("^%s*$") then
                    keys = "<Tab>"
                else
                    local sw = shift_width()
                    local previous_char = prefix:sub(#prefix, #prefix)
                    local previous_column = #prefix - #previous_char + 1
                    local current_column = vim.fn.virtcol({ vim.fn.line("."), previous_column }) + 1
                    local remainder = (current_column - 1) % sw
                    local move = remainder == 0 and sw or sw - remainder
                    keys = (" "):rep(move)
                end
            end
            feedkey(keys, "nt")
        end

        local confirm = function(entry)
            local behavior = cmp.ConfirmBehavior.Replace
            if entry then
                local completion_item = entry.completion_item
                local newText = completion_item.textEdit and completion_item.textEdit.newText
                    or (type(completion_item.insertText) == "string" and completion_item.insertText)
                    or completion_item.word or completion_item.label or ""
                local diff_after = math.max(0, entry.replace_range["end"].character + 1) - entry.context.cursor.col
                if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
                    behavior = cmp.ConfirmBehavior.Insert
                end
            end
            cmp.confirm({ select = true, behavior = behavior })
        end

        cmp.setup({
            snippet = {
                expand = function(args)
                    if has_luasnip then
                        luasnip.lsp_expand(args.body)
                    end
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-t>"] = cmp.mapping(toggle_completion, { "i" }),
                ["<C-y>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        local entry = cmp.get_selected_entry()
                        confirm(entry)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        local entry = cmp.get_selected_entry()
                        confirm(entry)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        local entries = cmp.get_entries()
                        if #entries == 1 then
                            confirm(entries[1])
                        else
                            cmp.select_next_item()
                        end
                    elseif has_luasnip and luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    elseif in_whitespace() then
                        smart_tab()
                    else
                        cmp.complete()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif has_luasnip and in_snippet() and luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    elseif in_leading_indent() then
                        smart_bs(true)
                    elseif in_whitespace() then
                        smart_bs()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp", priority = 1000 },
                { name = "luasnip", priority = 750 },
                { name = "buffer", priority = 500 },
                { name = "path", priority = 250 },
            }),
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    ellipsis_char = "…",
                    symbol_map = {
                        Text = "",
                        Method = "󰆧",
                        Function = "󰊕",
                        Constructor = "",
                        Field = "󰜢",
                        Variable = "󰀫",
                        Class = "󰠱",
                        Interface = "",
                        Module = "󰏗",
                        Property = "󰜢",
                        Unit = "󰑭",
                        Value = "󰎠",
                        Enum = "",
                        Keyword = "󰌋",
                        Snippet = "󰄫",
                        Color = "󰏘",
                        File = "󰈙",
                        Reference = "󰈇",
                        Folder = "󰉋",
                        EnumMember = "󰅲",
                        Constant = "󰏿",
                        Struct = "󰙅",
                        Event = "",
                        Operator = "󰆕",
                        TypeParameter = "󰊄",
                    },
                    before = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name]
                        return vim_item
                    end,
                }),
            },
            window = {
                completion = cmp.config.window.bordered({
                    border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
                    col_offset = -3,
                    side_padding = 1,
                }),
                documentation = cmp.config.window.bordered({
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                    winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
                }),
            },
            experimental = {
                ghost_text = false, -- Controlled by toggle_ghost_text
            },
        })

        -- Command-line completion
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
                { name = "cmdline" },
            }),
        })

        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- Ghost text toggle at word boundaries
        local toggle_ghost_text = function()
            if vim.api.nvim_get_mode().mode ~= "i" then return end
            local cursor_column = vim.fn.col(".")
            local current_line_contents = vim.fn.getline(".")
            local character_after_cursor = current_line_contents:sub(cursor_column, cursor_column)
            local should_enable_ghost_text = character_after_cursor == "" or vim.fn.match(character_after_cursor, [[\k]]) == -1
            -- Use a local variable to track ghost text state
            local current_config = cmp.get_config()
            local current_ghost_text = current_config.experimental and current_config.experimental.ghost_text or false
            if current_ghost_text ~= should_enable_ghost_text then
                cmp.setup({
                    experimental = { ghost_text = should_enable_ghost_text },
                })
            end
        end

        vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, {
            callback = toggle_ghost_text,
        })

        -- Define highlight groups
        local function set_cmp_highlights()
            local hl_groups = {
                CmpItemKindSnippet = { fg = colors.purple },
                CmpItemKindBuffer = { fg = colors.green },
                CmpItemKindPath = { fg = colors.orange },
                NormalFloat = { bg = colors.bg_lighter },
                FloatBorder = { fg = colors.blue, bg = colors.bg_lighter },
            }
            for group, opts in pairs(hl_groups) do
                pcall(vim.api.nvim_set_hl, 0, group, opts)
            end
        end

        set_cmp_highlights()
    end,
}

