return {
    name = "G++ build cpp file",
    builder = function()
        local file = vim.fn.expand("%:p")
        local outfile = '/tmp/' .. vim.fn.expand("%:t:r")
        return {
            cmd = { "g++" },
            args = { file, "-std=c++14", "-Wall", "-lm", "-g", "-o", outfile },
            components = { { "on_output_quickfix", open = false }, "default" },
        }
    end,
    condition = {
        filetype = { "cpp" },
        dir = "/home/xinglinsong/code/"
    },
}
