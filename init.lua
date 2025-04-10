require('options') -- 选项
require('keymaps') -- 快捷键
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        local function _trigger()
            vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazyFile" })
        end
        if vim.bo.filetype == "snacks_dashboard" then
            vim.api.nvim_create_autocmd("BufRead", {
                once = true,
                callback = _trigger,
            })
        else
            _trigger()
        end
        vim.go.laststatus = 3
        vim.o.splitkeep = "screen"
    end,
})
require('lazy-init') -- lazy.nvim
vim.cmd[[colorscheme catppuccin-mocha]] -- 主题
