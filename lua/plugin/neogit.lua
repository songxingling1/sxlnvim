return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",         -- required
        "sindrets/diffview.nvim",        -- optional - Diff integration
    },
    config = true,
    lazy = true,
    cmd = {"Neogit","NeogitCommit","NeogitLogCurrent","NeogitResetState"},
    keys = {
        {"<leader>gg",":Neogit<CR>",mode = "n",desc = "Neogit",noremap = true, silent = true}
    }
}
