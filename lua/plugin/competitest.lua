return {
    'xeluxee/competitest.nvim',
    dependencies = 'MunifTanjim/nui.nvim',
    config = function()
        require('competitest').setup({
            testcases_directory = './.ctt',
            compile_directory = './.ctt',
            compile_command = {
                cpp = { exec = "g++", args = { "-Wall", "$(FABSPATH)", "-o", "$(FNOEXT)" , "-std=c++14", "-lm", "-O2"} },
            },
            running_directory = "./.ctt",
        })
    end,
    lazy = true,
    cmd = "CompetiTest",
    keys = {
        {"<leader>ca",":CompetiTest add_testcase<CR>",mode = "n",desc = "Add Testcase",noremap = true, silent = true},
        {"<leader>cd",":CompetiTest delete_testcase<CR>",mode = "n",desc = "Delete Testcase",noremap = true, silent = true},
        {"<leader>cr",":CompetiTest run<CR>",mode = "n",desc = "Run",noremap = true, silent = true},
        {"<leader>cu",":CompetiTest show_ui<CR>",mode = "n",desc = "Show UI",noremap = true, silent = true},
        {"<leader>cp",":CompetiTest receive problem<CR>",mode = "n",desc = "Receive Problem",noremap = true, silent = true},
    }
}
