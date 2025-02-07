return {
    name = "Build and run cpp file",
    builder = function()
        local file = vim.fn.expand("%:p")
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
            components = { {
                "dependencies",
                task_names =  {
                    {
                        cmd = { "g++" },
                        args = { file, "-std=c++14", "-Wall", "-lm", "-g", "-o", outfile },
                    }
                }
            }, "default" }
        }
    end,
    condition = {
        filetype = { "cpp" },
    },
}
