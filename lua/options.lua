-- 文件编码
vim.g.encoding = "UTF-8"
vim.o.fileencoding = 'UTF-8'

-- jk 上下保留两行
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- Tab
vim.o.tabstop = 4 -- Tab 宽度
vim.o.softtabstop = 4
vim.o.expandtab = true -- 转换Tab为空格
vim.o.shiftwidth = 4 -- Tab 宽度
vim.o.autoindent = true -- 自动缩进
vim.o.smartindent = true -- 同上

-- UI
vim.o.number = true -- 行号
vim.o.relativenumber = true -- 相对行号
vim.o.cursorline = true -- 高亮当前行
vim.o.showmode = false -- 显示模式
vim.o.wrap = true -- 折行
vim.o.splitbelow = true -- split windows从下面上面出现
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.list = true
vim.o.listchars = "trail:.,tab:->"

vim.o.signcolumn = 'yes'
vim.o.clipboard = 'unnamedplus'

vim.o.laststatus = 3
vim.o.splitkeep = "screen"

vim.g.suda_smart_edit = 1

vim.o.cmdheight = 0

if vim.loop.os_uname().sysname == 'Windows_NT' then
    vim.o.shell = 'pwsh.exe'
    vim.o.shellcmdflag = '-nologo -c'
    vim.o.shellxquote = ''
    vim.o.shellquote = '"'
end
