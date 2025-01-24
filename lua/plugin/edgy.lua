return {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.laststatus = 3
        vim.o.splitkeep = "screen"
    end,
    keys = {
        {
            "<leader>ue",
            function()
                require("edgy").toggle()
            end,
            desc = "Edgy Toggle",
        },
        -- stylua: ignore
        { "<leader>uE", function() require("edgy").select() end, desc = "Edgy Select Window" },
    },
    opts = function()
        local opts = {
            bottom = {
                {
                    ft = "toggleterm",
                    size = { height = 0.2 },
                    filter = function(buf, win)
                        return vim.api.nvim_win_get_config(win).relative == ""
                    end,
                },
                {
                    ft = "noice",
                    size = { height = 0.2 },
                    filter = function(buf, win)
                        return vim.api.nvim_win_get_config(win).relative == ""
                    end,
                },
                "Trouble",
                { ft = "qf", title = "QuickFix" },
                {
                    ft = "help",
                    size = { height = 20 },
                    -- don't open help files in edgy that we're editing
                    filter = function(buf)
                        return vim.bo[buf].buftype == "help"
                    end,
                },
                { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
                { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
                { title = "Dap Console", ft = "dap-repl", size = {height = 0.2} },
                { title = "Dapui Terminal", ft = "dapui_console", size = {height = 0.2} },
            },
            left = {
                { title = "Neotest Summary", ft = "neotest-summary" },
                -- "neo-tree",
                { title = "Dapui Scopes", ft = "dapui_scopes", size = {height = 0.2} },
                { title = "Dapui Breakpoints", ft = "dapui_breakpoints", size = {height = 0.2} },
                { title = "Dapui Stacks", ft = "dapui_stacks", size = {height = 0.2} },
                { title = "Dapui Watches", ft = "dapui_watches", size = {height = 0.2} },
            },
            right = {
                {
                    title = "Grug Far",
                    ft = "grug-far",
                    size = {width = 80}
                }
            }
        }
        local pos = {
            filesystem = "left",
            buffers = "top",
            git_status = "right",
            document_symbols = "bottom",
            diagnostics = "bottom",
        }
        local sources = { "filesystem", "buffers", "git_status" }
        for i, v in ipairs(sources) do
            table.insert(opts.left, i, {
                title = "Neo-Tree " .. v:gsub("_", " "):gsub("^%l", string.upper),
                ft = "neo-tree",
                filter = function(buf)
                    return vim.b[buf].neo_tree_source == v
                end,
                pinned = true,
                open = function()
                    vim.cmd(("Neotree show position=%s %s"):format(pos[v] or "bottom", v))
                end,
            })
        end

        -- trouble
        for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
            opts[pos] = opts[pos] or {}
            table.insert(opts[pos], {
                ft = "trouble",
                filter = function(_buf, win)
                    return vim.w[win].trouble
                        and vim.w[win].trouble.position == pos
                        and vim.w[win].trouble.type == "split"
                        and vim.w[win].trouble.relative == "editor"
                        and not vim.w[win].trouble_preview
                end,
            })
        end

        -- snacks terminal
        for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
            opts[pos] = opts[pos] or {}
            table.insert(opts[pos], {
                ft = "snacks_terminal",
                size = { height = 0.2 },
                title = "%{b:snacks_terminal.id}: %{b:term_title}",
                filter = function(_buf, win)
                    return vim.w[win].snacks_win
                        and vim.w[win].snacks_win.position == pos
                        and vim.w[win].snacks_win.relative == "editor"
                        and not vim.w[win].trouble_preview
                end,
            })
        end
        return opts
    end,
}
