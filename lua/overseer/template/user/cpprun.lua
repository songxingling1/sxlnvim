return {
    name = "Run builded cpp file",
    builder = function()
        local outfile = '/tmp/' .. vim.fn.expand("%:t:r")
        return {
            cmd = { outfile },
            strategy = {
                "toggleterm",
                hidden = false,
                quit_on_exit = "never"
            },
        }
    end,
    condition = {
        filetype = { "cpp" },
    },
}
