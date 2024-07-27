-- Function to save the last position
local function save_last_position()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    if line > 1 or col > 0 then
        vim.b.last_cursor_pos = {line, col}
    end
end

-- Function to restore the last position
local function restore_last_position()
    local last_pos = vim.b.last_cursor_pos
    if last_pos then
        local line, col = unpack(last_pos)
        vim.api.nvim_win_set_cursor(0, {line, col})
    end
end

-- Create autocommands to save and restore position
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local line = vim.fn.line("'\"")
        if line > 1 and line <= vim.fn.line("$") then
            vim.api.nvim_win_set_cursor(0, {line, 0})
            vim.cmd("normal! zvzz")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*",
    callback = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        if line > 1 or col > 0 then
            vim.cmd("normal! m\"")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = save_last_position,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = restore_last_position,
})

