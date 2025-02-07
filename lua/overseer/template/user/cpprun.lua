return {
    name = "Run builded cpp file",
    builder = function()
        local outfile = '/tmp/' .. vim.fn.expand("%:t:r")
        if vim.loop.os_uname().sysname == 'Windows_NT' then
            outfile = vim.loop.os_getenv('TEMP') .. '\\' .. vim.fn.expand("%:t:r") .. '.exe'
        end
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
