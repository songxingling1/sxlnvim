return {
    {
        "yelog/marklive.nvim",
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        lazy = true,
        ft = "markdown",
        opts = {}
    },
    {
        "davidgranstrom/nvim-markdown-preview",
        lazy = true,
        ft = "markdown"
    }
}
