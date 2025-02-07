-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    { import = "plugin.edgy" },
    { import = "plugin.neotree" },
    { import = "plugin.theme" },
    { import = "plugin.heirline" },
    { import = "plugin.lsp" },
    { import = "plugin.noice" },
    { import = "plugin.snacks" },
    { import = "plugin.code" },
    { import = "plugin.whichkey" },
    { import = "plugin.rainbow" },
    { import = "plugin.nvimwindow" },
    { import = "plugin.mini" },
    { import = "plugin.grugfar" },
    { import = "plugin.yazi" },
    { import = "plugin.neogit" },
    { import = "plugin.marklive" },
    { import = "plugin.competitest" },
    {
        "echasnovski/mini.icons",
        lazy = true,
        opts = {
            file = {
                [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
                ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
            },
            filetype = {
                dotenv = { glyph = "", hl = "MiniIconsYellow" },
            },
        },
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
    { "akinsho/toggleterm.nvim", lazy = true },
    { "lambdalisue/vim-suda", lazy = true, event = "BufReadPre"},
})
