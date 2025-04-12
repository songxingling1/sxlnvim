return {
    {
        'stevearc/overseer.nvim',
        dependencies = {"akinsho/toggleterm.nvim"},
        opts = {
            dap = false,
            templates = { "builtin", "user.cppbuild", "user.cpprun", "user.cppbar" },
        },
        lazy = true,
        cmd = {
            "OverseerBuild",
            "OverseerClearCache",
            "OverseerClose",
            "OverseerDeleteBundle",
            "OverseerInfo",
            "OverseerLoadBundle",
            "OverseerOpen",
            "OverseerQuickAction",
            "OverseerRun",
            "OverseerRunCmd",
            "OverseerSaveBundle",
            "OverseerTaskAction",
            "OverseerToggle"
        }
    },
    {
        "mfussenegger/nvim-dap",
        lazy = true,
        keys = {
            {
                "<leader>dp",
                function()
                    vim.ui.input({prompt = 'Condition?'},function(val)
                        require('dap').toggle_breakpoint(val)
                    end)
                end,
                mode = "n",
                desc = "Toggle condition breakpoint"
            },
            { "<leader>db", function()require('dap').toggle_breakpoint()end, mode = "n", desc = "Toggle breakpoint"},
            { "<leader>dc", function()require('dap').continue()end, mode = "n", desc = "Start debugging or continue"},
            { "<leader>df", function()require('dap').close()end, mode = "n", desc = "Finish debugging"},
            { "<leader>dn", function()require('dap').step_over()end, mode = "n", desc = "Step over"},
            { "<leader>ds", function()require('dap').step_into()end, mode = "n", desc = "Step into"},
        },
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                opts = {},
                dependencies = { "nvim-neotest/nvim-nio" },
                config = function(_,opts)
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                      dapui.open({})
                    end
                end,
                keys = {
                    { "<leader>duo", function()require('dapui').open({})end, mode = "n", desc = "Open Dapui"},
                    { "<leader>duc", function()require('dapui').close({})end, mode = "n", desc = "Close Dapui"},
                }
            },
            -- virtual text for the debugger
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {},
            },
        },
        config = function()
            local dap = require("dap")
            require('overseer').enable_dap()
            local icons = {
                Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
                Breakpoint = " ",
                BreakpointCondition = " ",
                BreakpointRejected = { " ", "DiagnosticError" },
                LogPoint = ".>",
            }
            for name, sign in pairs(icons) do
                sign = type(sign) == "table" and sign or { sign }
                vim.fn.sign_define(
                    "Dap" .. name,
                    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
                )
            end
            dap.adapters.cppdbg = {
                type = "executable",
                command = "OpenDebugAD7",
                id = 'cppdbg',
                options = {
                    detached = false
                }
            }
            for _, lang in ipairs({ "c", "cpp" }) do
                dap.configurations[lang] = {
                    {
                        type = "cppdbg",
                        request = "launch",
                        name = "Launch file",
                        program = function()
                            if vim.loop.os_uname().sysname == 'Windows_NT' then
                                return vim.loop.os_getenv('TEMP') .. '\\' .. vim.fn.expand("%:t:r") .. '.exe'
                            end
                            return '/tmp/' .. vim.fn.expand("%:t:r")
                        end,
                        cwd = "${workspaceFolder}",
                        stopAtEntry = false,
                        setupCommands = {  
                          {
                             text = '-enable-pretty-printing',
                             description =  'enable pretty printing',
                             ignoreFailures = false 
                          },
                        },
                        preLaunchTask = "G++ build cpp file"
                    },
                }
            end
        end
    },
}
