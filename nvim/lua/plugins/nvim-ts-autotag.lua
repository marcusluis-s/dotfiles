return {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("nvim-ts-autotag").setup({ 
            opts = {
                enable_tag_close = true,
                enable_tag_rename = true,
                enable_close_on_slash = false
            },
            per_filetype = {
                ["html"] = {
                    enable_close = false
                }
            },
        })
    end,
}
