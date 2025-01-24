return {
    {
        "neovim/nvim-lspconfig",
        dependencies = { 'saghen/blink.cmp' },
        config = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            local lspconfig = require('lspconfig')
            lspconfig['clangd'].setup({ capabilities = capabilities, 
                on_attach = function(client, bufnr)require('nvim-navic').attach(client, bufnr)end})
        end,
        lazy = true,
        event = "BufRead"
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function () 
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = { "cpp" },
                sync_install = true,
                highlight = { enable = true },
                indent = { enable = true },  
            })
        end,
        lazy = true,
        event = "BufReadPre"
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        lazy = true,
        event = "User VeryLazyFile"
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        lazy = true,
        event = "User VeryLazyFile",
        config = function()
            local opts = {
                textobjects = {
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = { query = "@class.outer", desc = "Next class start" },
                            ["]o"] = "@loop.*",
                            ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
                            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                        goto_next = {
                            ["]d"] = "@conditional.outer",
                        },
                        goto_previous = {
                            ["[d"] = "@conditional.outer",
                        }
                    },
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = 'V', -- linewise
                        },
                        include_surrounding_whitespace = true,
                    },
                },
            }
            require('nvim-treesitter.configs').setup(opts)
        end
    },
    {
        'saghen/blink.cmp',
        lazy = true, -- lazy loading handled internally
        event = "InsertEnter",
        dependencies = 'rafamadriz/friendly-snippets',
        version = 'v0.*',
        opts = {
            keymap = { preset = 'super-tab', ["C-n"] = { 'select_next' }, ["<C-p>"] = { 'select_prev' } },
            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = 'normal'
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
        },
        opts_extend = { "sources.default" }
    },
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        event = "User VeryLazyFile"
    },
    {
        "folke/trouble.nvim",
        lazy = true,
        event = "User VeryLazyFile"
    }
}
