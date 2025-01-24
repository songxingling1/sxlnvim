return {
    name = "Build and run cpp file",
    builder = function()
        local file = vim.fn.expand("%:p")
        local outfile = '/tmp/' .. vim.fn.expand("%:t:r")
        return {
            cmd = { 'consolepauser' },
            args = {outfile},
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
