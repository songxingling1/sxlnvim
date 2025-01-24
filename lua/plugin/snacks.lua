return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = true,
    event = "UIEnter",
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        picker = {
            win = {
                input = {
                    keys = {
                        ["<a-c>"] = {
                            "toggle_cwd",
                            mode = { "n", "i" },
                        },
                    },
                },
            },
            actions = {
                toggle_cwd = function(p)
                    local root = RootGet({ buf = p.input.filter.current_buf, normalize = true })
                    local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
                    local current = p:cwd()
                    p:set_cwd(current == root and cwd or root)
                    p:find()
                end,
            },
        },
        dashboard = {
            enabled = true,
            preset = {
                pick = function(cmd, opts)
                    return require("snacks").picker.pick(cmd, opts)()
                end,
                keys = {
                    { icon = " ", key = "l", desc = "Open Neo-tree", action = ":Neotree" },
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.pick('oldfiles')" },
                    { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.pick('files', {cwd = vim.fn.stdpath('config')})" },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
                header = [[
███████╗██╗  ██╗██╗     ███╗   ██╗██╗   ██╗██╗███╗   ███╗
██╔════╝╚██╗██╔╝██║     ████╗  ██║██║   ██║██║████╗ ████║
███████╗ ╚███╔╝ ██║     ██╔██╗ ██║██║   ██║██║██╔████╔██║
╚════██║ ██╔██╗ ██║     ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
███████║██╔╝ ██╗███████╗██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]]
            }
        },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        picker = { enabled = true},
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
}
