vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("RestoreCursor", { clear = true }),
    pattern = "*",
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.api.nvim_buf_get_option(buf, "filetype")
        local bufname = vim.api.nvim_buf_get_name(buf)
        -- Evita restaurar em buffers especiais (oil.nvim, buffers sem nome, commits, etc.)
        if ft ~= "oil" and bufname ~= "" and ft ~= "gitcommit" and ft ~= "gitrebase" then
            local mark = vim.api.nvim_buf_get_mark(buf, '"')
            local lcount = vim.api.nvim_buf_line_count(buf)
            if mark[1] > 0 and mark[1] <= lcount then
                vim.api.nvim_win_set_cursor(0, mark)
                print("Restored cursor to line " .. mark[1] .. " in " .. bufname) -- Debug
            end
        end
    end,
    desc = "Restore cursor to last position",
})

-- Configuração do shada para salvar marcas globais
vim.opt.shada = "'1000,f1,<50,s10,h"
