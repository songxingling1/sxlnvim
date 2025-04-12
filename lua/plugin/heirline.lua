return {
    "rebelot/heirline.nvim",
    lazy = true,
    event = "UIEnter",
    config = function()
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")
        local heirline = require("heirline")
        local Space = { provider="  " }
        local ReverseSpace = { provider="  " }
        local Align = { provider="%=" }
        local colors = {
            bright_bg = utils.get_highlight("Folded").bg,
            bright_fg = utils.get_highlight("Folded").fg,
            red = utils.get_highlight("DiagnosticError").fg,
            dark_red = utils.get_highlight("DiffDelete").bg,
            green = utils.get_highlight("String").fg,
            blue = utils.get_highlight("Function").fg,
            gray = utils.get_highlight("NonText").fg,
            orange = utils.get_highlight("Constant").fg,
            purple = utils.get_highlight("Statement").fg,
            cyan = utils.get_highlight("Special").fg,
            diag_warn = utils.get_highlight("DiagnosticWarn").fg,
            diag_error = utils.get_highlight("DiagnosticError").fg,
            diag_hint = utils.get_highlight("DiagnosticHint").fg,
            diag_info = utils.get_highlight("DiagnosticInfo").fg,
            git_del = '#f38ba8',
            git_add = '#a6e3a1',
            git_change = '#89b4fa',
        }
        heirline.load_colors(colors)
        local ViMode = {
            -- get vim current mode, this information will be required by the provider
            -- and the highlight functions, so we compute it only once per component
            -- evaluation and store it as a component attribute
            init = function(self)
                self.mode = vim.fn.mode(1) -- :h mode()
            end,
            -- Now we define some dictionaries to map the output of mode() to the
            -- corresponding string and color. We can put these into `static` to compute
            -- them at initialisation time.
            static = {
                mode_names = { -- change the strings if you like it vvvvverbose!
                    n = "N",
                    no = "N?",
                    nov = "N?",
                    noV = "N?",
                    ["no\22"] = "N?",
                    niI = "Ni",
                    niR = "Nr",
                    niV = "Nv",
                    nt = "Nt",
                    v = "V",
                    vs = "Vs",
                    V = "V_",
                    Vs = "Vs",
                    ["\22"] = "^V",
                    ["\22s"] = "^V",
                    s = "S",
                    S = "S_",
                    ["\19"] = "^S",
                    i = "I",
                    ic = "Ic",
                    ix = "Ix",
                    R = "R",
                    Rc = "Rc",
                    Rx = "Rx",
                    Rv = "Rv",
                    Rvc = "Rv",
                    Rvx = "Rv",
                    c = "C",
                    cv = "Ex",
                    r = "...",
                    rm = "M",
                    ["r?"] = "?",
                    ["!"] = "!",
                    t = "T",
                },
                mode_colors = {
                    n = "green" ,
                    i = "blue",
                    v = "red",
                    V =  "red",
                    ["\22"] =  "red",
                    c =  "#fab387",
                    s =  "purple",
                    S =  "purple",
                    ["\19"] =  "purple",
                    R =  "#fab387",
                    r =  "#fab387",
                    ["!"] =  "cyan",
                    t =  "red",
                }
            },
            -- We can now access the value of mode() that, by now, would have been
            -- computed by `init()` and use it to index our strings dictionary.
            -- note how `static` fields become just regular attributes once the
            -- component is instantiated.
            -- To be extra meticulous, we can also add some vim statusline syntax to
            -- control the padding and make sure our string is always at least 2
            -- characters long. Plus a nice Icon.
            provider = function(self)
                return " %2("..self.mode_names[self.mode].."%)"
            end,
            -- Same goes for the highlight. Now the foreground will change according to the current mode.
            hl = function(self)
                local mode = self.mode:sub(1, 1) -- get only the first mode character
                return { fg = self.mode_colors[mode], bold = true, }
            end,
            -- Re-evaluate the component only on ModeChanged event!
            -- Also allows the statusline to be re-evaluated when entering operator-pending mode
            update = {
                "ModeChanged",
                pattern = "*:*",
                callback = vim.schedule_wrap(function()
                    vim.cmd("redrawstatus")
                end),
            },
        }
        local FileNameBlock = {
            -- let's first set up some attributes needed by this component and its children
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
            end,
        }
        -- We can now define some children separately and add them later
        local FileIcon = {
            init = function(self)
                local filename = self.filename
                local extension = vim.fn.fnamemodify(filename, ":e")
                self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
            end,
            provider = function(self)
                return self.icon and (self.icon .. " ")
            end,
            hl = function(self)
                return { fg = self.icon_color }
            end
        }
        local FileName = {
            provider = function(self)
                -- first, trim the pattern relative to the current directory. For other
                -- options, see :h filename-modifers
                local filename = vim.fn.fnamemodify(self.filename, ":.")
                if filename == "" then return "[No Name]" end
                -- now, if the filename would occupy more than 1/4th of the available
                -- space, we trim the file path to its initials
                -- See Flexible Components section below for dynamic truncation
                if not conditions.width_percent_below(#filename, 0.25) then
                    filename = vim.fn.pathshorten(filename)
                end
                return filename
            end,
            hl = { fg = utils.get_highlight("Directory").fg },
        }
        local FileFlags = {
            {
                condition = function()
                    return vim.bo.modified
                end,
                provider = "[+]",
                hl = { fg = "green" },
            },
            {
                condition = function()
                    return not vim.bo.modifiable or vim.bo.readonly
                end,
                provider = "",
                hl = { fg = "orange" },
            },
        }
        -- Now, let's say that we want the filename color to change if the buffer is
        -- modified. Of course, we could do that directly using the FileName.hl field,
        -- but we'll see how easy it is to alter existing components using a "modifier"
        -- component

        local FileNameModifer = {
            hl = function()
                if vim.bo.modified then
                    -- use `force` because we need to override the child's hl foreground
                    return { fg = "cyan", bold = true, force=true }
                end
            end,
        }
        local FileType = {
            provider = function()
                if vim.bo.filetype == 'snacks_dashboard' then
                    return ""
                elseif vim.bo.filetype == 'neo-tree' then
                    return "Neo-Tree"
                elseif vim.bo.filetype == 'grug-far' then
                    return "Grug Far"
                elseif vim.bo.filetype == 'NeogitStatus' then
                    return ""
                end
                return string.upper(vim.bo.filetype)
            end,
            hl = { fg = utils.get_highlight("Type").fg, bold = true },
        }
        -- let's add the children to our FileNameBlock component
        FileNameBlock = utils.insert(FileNameBlock,
            FileIcon,
            utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
            FileFlags,
            { provider = '%<'} -- this means that the statusline is cut here when there's not enough space
        )
        local FileFormat = {
            provider = function()
                local fmt = vim.bo.fileformat
                if fmt == 'unix' then
                    return ''
                else
                    return ''
                end
            end
        }
        -- We're getting minimalist here!
        local Ruler = {
            -- %l = current line number
            -- %L = number of lines in the buffer
            -- %c = column number
            -- %P = percentage through file of displayed window
            provider = "%7(%l/%3L%):%2c %P",
        }
        -- I take no credits for this! 🦁
        local ScrollBar ={
            static = {
                sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
            },
            provider = function(self)
                local curr_line = vim.api.nvim_win_get_cursor(0)[1]
                local lines = vim.api.nvim_buf_line_count(0)
                local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
                return string.rep(self.sbar[i], 2)
            end,
            hl = { fg = "blue", bg = "bright_bg" },
        }
        local LSPActive = {
            condition = conditions.lsp_attached,
            update = {'LspAttach', 'LspDetach'},
            -- You can keep it simple,
            -- provider = " [LSP]",
            -- Or complicate things a bit and get the servers names
            provider = function()
                local names = {}
                for i, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                    table.insert(names, server.name)
                end
                return " [" .. table.concat(names, " ") .. "]"
            end,
            hl = { fg = "green", bold = true },
        }
        local Navic = {
            condition = function() return require("nvim-navic").is_available() end,
            static = {
                -- create a type highlight map
                type_hl = {
                    File = "Directory",
                    Module = "@include",
                    Namespace = "@namespace",
                    Package = "@include",
                    Class = "@structure",
                    Method = "@method",
                    Property = "@property",
                    Field = "@field",
                    Constructor = "@constructor",
                    Enum = "@field",
                    Interface = "@type",
                    Function = "@function",
                    Variable = "@variable",
                    Constant = "@constant",
                    String = "@string",
                    Number = "@number",
                    Boolean = "@boolean",
                    Array = "@field",
                    Object = "@type",
                    Key = "@keyword",
                    Null = "@comment",
                    EnumMember = "@field",
                    Struct = "@structure",
                    Event = "@keyword",
                    Operator = "@operator",
                    TypeParameter = "@type",
                },
                -- bit operation dark magic, see below...
                enc = function(line, col, winnr)
                    return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
                end,
                -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
                dec = function(c)
                    local line = bit.rshift(c, 16)
                    local col = bit.band(bit.rshift(c, 6), 1023)
                    local winnr = bit.band(c, 63)
                    return line, col, winnr
                end
            },
            init = function(self)
                local data = require("nvim-navic").get_data() or {}
                local children = {}
                -- create a child for each level
                for i, d in ipairs(data) do
                    -- encode line and column numbers into a single integer
                    local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
                    local child = {
                        {
                            provider = d.icon,
                            hl = self.type_hl[d.type],
                        },
                        {
                            -- escape `%`s (elixir) and buggy default separators
                            provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ''),
                            -- highlight icon only or location name as well
                            -- hl = self.type_hl[d.type],

                            on_click = {
                                -- pass the encoded position through minwid
                                minwid = pos,
                                callback = function(_, minwid)
                                    -- decode
                                    local line, col, winnr = self.dec(minwid)
                                    vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), {line, col})
                                end,
                                name = "heirline_navic",
                            },
                        },
                    }
                    -- add a separator only if needed
                    if #data > 1 and i < #data then
                        table.insert(child, {
                            provider = " > ",
                            hl = { fg = 'bright_fg' },
                        })
                    end
                    table.insert(children, child)
                end
                -- instantiate the new child, overwriting the previous one
                self.child = self:new(children, 1)
            end,
            -- evaluate the children containing navic components
            provider = function(self)
                return self.child:eval()
            end,
            hl = { fg = "gray" },
            update = 'CursorMoved'
        }
        local Diagnostics = {
            condition = conditions.has_diagnostics,
            static = {
                error_icon = ' ',
                warn_icon = ' ',
                info_icon = ' ',
                hint_icon = ' ',
            },

            init = function(self)
                self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            end,
            update = { "DiagnosticChanged", "BufEnter" },
            {
                provider = "![",
            },
            {
                provider = function(self)
                    -- 0 is just another output, we can decide to print it or not!
                    return self.errors > 0 and (self.error_icon .. self.errors .. " ")
                end,
                hl = { fg = "diag_error" },
            },
            {
                provider = function(self)
                    return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
                end,
                hl = { fg = "diag_warn" },
            },
            {
                provider = function(self)
                    return self.info > 0 and (self.info_icon .. self.info .. " ")
                end,
                hl = { fg = "diag_info" },
            },
            {
                provider = function(self)
                    return self.hints > 0 and (self.hint_icon .. self.hints)
                end,
                hl = { fg = "diag_hint" },
            },
            {
                provider = "]",
            },
            on_click = {
                callback = function()
                    require("trouble").toggle({ mode = "diagnostics" })
                    -- or
                    -- vim.diagnostic.setqflist()
                end,
                name = "heirline_diagnostics",
            },
        }
        local Git = {
            condition = conditions.is_git_repo,
            init = function(self)
                self.status_dict = vim.b.gitsigns_status_dict
                self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
            end,
            hl = { fg = "orange" },
            {   -- git branch name
                provider = function(self)
                    return " " .. self.status_dict.head
                end,
                hl = { bold = true }
            },
            -- You could handle delimiters, icons and counts similar to Diagnostics
            {
                condition = function(self)
                    return self.has_changes
                end,
                provider = "("
            },
            {
                provider = function(self)
                    local count = self.status_dict.added or 0
                    return count > 0 and ("+" .. count)
                end,
                hl = { fg = "git_add" },
            },
            {
                provider = function(self)
                    local count = self.status_dict.removed or 0
                    return count > 0 and ("-" .. count)
                end,
                hl = { fg = "git_del" },
            },
            {
                provider = function(self)
                    local count = self.status_dict.changed or 0
                    return count > 0 and ("~" .. count)
                end,
                hl = { fg = "git_change" },
            },
            {
                condition = function(self)
                    return self.has_changes
                end,
                provider = ")",
            },
            on_click = {
                callback = function()
                    -- If you want to use Fugitive:
                    -- vim.cmd("G")

                    -- If you prefer Lazygit
                    -- use vim.defer_fn() if the callback requires
                    -- opening of a floating window
                    -- (this also applies to telescope)
                    vim.defer_fn(function()
                        vim.cmd("Neogit")
                    end, 100)
                end,
                name = "heirline_git",
            },
        }
        local HelpFileName = {
            condition = function()
                return vim.bo.filetype == "help"
            end,
            provider = function()
                local filename = vim.api.nvim_buf_get_name(0)
                return vim.fn.fnamemodify(filename, ":t")
            end,
            hl = { fg = colors.blue },
        }
        ViMode = utils.surround({ "█", " " }, "bright_bg", { ViMode })
        local TerminalName = {
            -- we could add a condition to check that buftype == 'terminal'
            -- or we could do that later (see #conditional-statuslines below)
            provider = function()
                local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
                return " " .. tname
            end,
            hl = { fg = "blue", bold = true },
        }
        local DefaultStatusline = {
            ViMode, FileNameBlock, {
                condition = conditions.is_git_repo,
                Space,
                Git,
            }, {
                condition = conditions.has_diagnostics,
                Space,
                Diagnostics,
            }, Align,
            Navic, Align,
            {
                condition = conditions.lsp_attached,
                LSPActive,
                ReverseSpace,
            }, FileType, ReverseSpace, FileFormat, ReverseSpace, Ruler , {provider=" "}, ScrollBar
        }
        local InactiveStatusline = {
            condition = conditions.is_not_active,
            FileType, Space, FileName, Align,
        }
        local SpecialStatusline = {
            condition = function()
                return conditions.buffer_matches({
                    buftype = { "nofile", "prompt", "help", "quickfix" },
                    filetype = { "^git.*", "fugitive" },
                })
            end,
            FileType, {
                condition = function()
                    return vim.bo.filetype == "help"
                end,
                Space,
                HelpFileName
            }, Align,
            hl = function()
                if vim.bo.filetype == "snacks_dashboard" then
                    return {bg="#1e1e2e"}
                elseif vim.bo.filetype == "NeogitStatus" then
                    return {bg="#1e1e2e"}
                end
            end
        }
        local TerminalStatusline = {
            condition = function()
                return conditions.buffer_matches({ buftype = { "terminal" } })
            end,
            -- Quickly add a condition to the ViMode to only show it when buffer is active!
            { condition = conditions.is_active, ViMode}, TerminalName, Align,
        }
        local StatusLines = {
            hl = function()
                if conditions.is_active() then
                    return "StatusLine"
                else
                    return "StatusLineNC"
                end
            end,
            -- the first statusline with no condition, or which condition returns true is used.
            -- think of it as a switch case with breaks to stop fallthrough.
            fallthrough = false,
            SpecialStatusline,
            TerminalStatusline,
            InactiveStatusline,
            DefaultStatusline,
        }
        local DiagnosticsTab = {
            condition = conditions.has_diagnostics,
            static = {
                error_icon = ' ',
                warn_icon = ' ',
                info_icon = ' ',
                hint_icon = ' ',
            },

            init = function(self)
                self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            end,
            update = { "DiagnosticChanged", "BufEnter" },
            {
                provider = function(self)
                    -- 0 is just another output, we can decide to print it or not!
                    return self.errors > 0 and (self.error_icon .. self.errors .. " ")
                end,
                hl = { fg = "diag_error" },
            },
            {
                provider = function(self)
                    return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
                end,
                hl = { fg = "diag_warn" },
            },
            {
                provider = function(self)
                    return self.info > 0 and (self.info_icon .. self.info .. " ")
                end,
                hl = { fg = "diag_info" },
            },
            {
                provider = function(self)
                    return self.hints > 0 and (self.hint_icon .. self.hints)
                end,
                hl = { fg = "diag_hint" },
            },
        }
        local WinBars = {
            fallthrough = false,
            {   -- A special winbar for terminals
                condition = function()
                    return conditions.buffer_matches({ buftype = { "terminal" } })
                end,
                utils.surround({ "", " " }, "bright_bg", {
                    TerminalName,
                }),
            },
            {   -- An inactive winbar for regular files
                condition = function()
                    return not conditions.is_active()
                end,
                utils.surround({ "", " " }, "bright_bg", { hl = { fg = "gray", force = true }, FileNameBlock }),
            },
            -- A winbar for regular files
            {
                utils.surround({ "", " " }, "bright_bg", { FileNameBlock }),
                {
                    condition = conditions.has_diagnostics,
                    DiagnosticsTab,
                    Space
                },
                Navic
            }
        }
        local TablineFileName = {
            provider = function(self)
                -- self.filename will be defined later, just keep looking at the example!
                local filename = self.filename
                filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
                return filename
            end,
            hl = function(self)
                if self.is_active then
                    return {bold = true, italic = true}
                -- why not?
                -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
                --     return { fg = "gray" }
                else
                    return {bold = self.is_visible, italic = true}
                end
            end,
        }
        -- this looks exactly like the FileFlags component that we saw in
        -- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
        -- also, we are adding a nice icon for terminal buffers.
        local TablineFileFlags = {
            {
                condition = function(self)
                    return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
                        or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
                end,
                provider = function(self)
                    if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
                        return "  "
                    else
                        return ""
                    end
                end,
                hl = { fg = "orange" },
            },
        }
        -- Here the filename block finally comes together
        local TablineFileNameBlock = {
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(self.bufnr)
            end,
            hl = function(self)
                if self.is_active then
                    return {fg="#89b4fa"}
                -- why not?
                -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
                --     return { fg = "gray" }
                else
                    return {fg="#6c7086"}
                end
            end,
            on_click = {
                callback = function(_, minwid, _, button)
                    if (button == "m") then -- close on mouse middle click
                        vim.schedule(function()
                            vim.api.nvim_buf_delete(minwid, { force = false })
                        end)
                    else
                        vim.api.nvim_win_set_buf(0, minwid)
                    end
                end,
                minwid = function(self)
                    return self.bufnr
                end,
                name = "heirline_tabline_buffer_callback",
            },
            FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
            TablineFileName,
            TablineFileFlags,
        }
        -- a nice "x" button to close the buffer
        local TablineCloseButton = {
            { provider = " " },
            {
                condition = function(self)
                    return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
                end,
                provider = "",
                hl = function(self)
                    if self.is_active then
                        return { fg = "#fab387" }
                    else
                        return { fg = "#45475a" }
                    end
                end,
                on_click = {
                    callback = function(_, minwid)
                        vim.schedule(function()
                            require('snacks.bufdelete').delete(minwid)
                            vim.cmd.redrawtabline()
                        end)
                    end,
                    minwid = function(self)
                        return self.bufnr
                    end,
                    name = "heirline_tabline_close_buffer_callback",
                },
            },
            {
                condition = function(self)
                    return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
                end,
                provider = "",
                hl = function(self)
                    if self.is_active then
                        return { fg = "#fab387" }
                    else
                        return { fg = "#45475a" }
                    end
                end,
                on_click = {
                    callback = function(_, minwid)
                        vim.schedule(function()
                            require('snacks.bufdelete').delete(minwid)
                            vim.cmd.redrawtabline()
                        end)
                    end,
                    minwid = function(self)
                        return self.bufnr
                    end,
                    name = "heirline_tabline_close_buffer_callback",
                },
            },
        }
        -- The final touch!
        local TablineBufferBlock = {
            {
                provider = "▍ ",
                hl = function()
                    return {fg="#89b4fa"}
                end,
                condition = function(self)
                    return self.is_active
                end
            },
            {
                provider = "▎ ",
                hl = function()
                    return {fg="#2a2b3c"}
                end,
                condition = function(self)
                    return not self.is_active
                end
            },
            {
                TablineFileNameBlock,
                hl = function(self)
                    if self.is_active then
                        return {fg="#89b4fa"}
                    else
                        return {fg="#6c7086"}
                    end
                end
            },
            {
                TablineCloseButton,
                hl = function(self)
                    if self.is_active then
                        return {fg="#89b4fa"}
                    else
                        return {fg="#6c7086"}
                    end
                end
            },{
                provider = "  "
            }
        }
        -- this is the default function used to retrieve buffers
        local get_bufs = function()
            return vim.tbl_filter(function(bufnr)
                return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
            end, vim.api.nvim_list_bufs())
        end
        -- initialize the buflist cache
        local buflist_cache = {}
        -- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
        vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
            callback = function()
                vim.schedule(function()
                    local buffers = get_bufs()
                    for i, v in ipairs(buffers) do
                        if vim.api.nvim_buf_get_name(v) == '' then
                            table.remove(buffers,i)
                        end
                    end
                    for i, v in ipairs(buffers) do
                        buflist_cache[i] = v
                    end
                    for i = #buffers + 1, #buflist_cache do
                        buflist_cache[i] = nil
                    end
                    -- check how many buffers we have and set showtabline accordingly
                    if #buflist_cache > 1 then
                        vim.o.showtabline = 2 -- always
                    elseif vim.o.showtabline ~= 1 then -- don't reset the option if it's already at default value
                        vim.o.showtabline = 1 -- only when #tabpages > 1
                    end
                end)
            end,
        })
        -- and here we go
        local BufferLine = utils.make_buflist(
                TablineBufferBlock,
                { provider = " ", hl = { fg = "gray" } }, -- left truncation, optional (defaults to "<")
                { provider = "", hl = { fg = "gray" } }, -- right trunctation, also optional (defaults to ...... yep, ">")
                -- out buf_func simply returns the buflist_cache
                function()
                    return buflist_cache
                end,
                -- no cache, as we're handling everything ourselves
                false
            )
        local TabLineOffset = {
            condition = function(self)
                local win = vim.api.nvim_tabpage_list_wins(0)[1]
                local bufnr = vim.api.nvim_win_get_buf(win)
                self.winid = win

                if vim.bo[bufnr].filetype == "neo-tree" then
                    self.title = "Neo-Tree"
                    return true
                elseif vim.bo[bufnr].filetype == "grug-far" then
                    self.title = "Grug Far"
                    return true
                elseif vim.bo[bufnr].filetype == "NeogitStatus" then
                    self.title = "Neogit"
                    return true
                end
            end,
            provider = function(self)
                local title = self.title
                local width = vim.api.nvim_win_get_width(self.winid)
                local pad = math.ceil((width - #title) / 2)
                return string.rep(" ", pad) .. title .. string.rep(" ", pad)
            end,
            hl = function(self)
                if vim.api.nvim_get_current_win() == self.winid then
                    return {fg="#89b4fa",bg="#45475a"}
                else
                    return {fg="#6c7086",bg="#11111b"}
                end
            end,
        }
        local TabLine = { TabLineOffset, BufferLine }
        heirline.setup({
            statusline = StatusLines,
            winbar = WinBars,
            tabline = TabLine,
            opts = {
                -- if the callback returns true, the winbar will be disabled for that window
                -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
                disable_winbar_cb = function(args)
                    return conditions.buffer_matches({
                        buftype = { "nofile", "prompt", "help", "quickfix" },
                        filetype = { "^git.*", "fugitive", "Trouble", "snacks_dashboard" },
                    }, args.buf)
                end,
            },
        })
    end,
}
