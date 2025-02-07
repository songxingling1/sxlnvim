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
        vim.o.laststatus = 3
        vim.o.splitkeep = "screen"
        vim.ui.input = function(opts,on_confirm)
            vim.api.nvim_exec_autocmds("User",{pattern = "InputPopupPre"})
            vim.ui.oldInput(opts,on_confirm)
            vim.api.nvim_exec_autocmds("User",{pattern = "InputPopup"})
        end
    end,
})
require('lazy-init') -- lazy.nvim
vim.cmd[[colorscheme catppuccin-mocha]] -- 主题

vim.ui.oldInput = vim.ui.input
