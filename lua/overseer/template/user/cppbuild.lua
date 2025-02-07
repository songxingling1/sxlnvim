return {
    name = "G++ build cpp file",
    builder = function()
        local file = vim.fn.expand("%:p")
        local outfile = '/tmp/' .. vim.fn.expand("%:t:r")
        if vim.loop.os_uname().sysname == 'Windows_NT' then
            outfile = vim.loop.os_getenv('TEMP') .. '\\' .. vim.fn.expand("%:t:r") .. '.exe'
        end
        return {
            cmd = { "g++" },
            args = { file, "-std=c++14", "-Wall", "-lm", "-g", "-o", outfile },
        }
    end,
    condition = {
        filetype = { "cpp" },
    },
}
