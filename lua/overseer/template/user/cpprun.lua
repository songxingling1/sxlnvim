return {
    name = "Run builded cpp file",
    builder = function()
        local outfile = '/tmp/' .. vim.fn.expand("%:t:r")
        return {
            cmd = { 'consolepauser' },
            args = { outfile }
        }
    end,
    condition = {
        filetype = { "cpp" },
        dir = "/home/xinglinsong/code/"
    },
}
