local opt = {noremap = true,silent = true}
vim.g.mapleader = " "
vim.g.maplocalleader = ','
vim.keymap.set('i','jk','<ESC>',{desc = "Exit insert mode"})
vim.keymap.set('n','<leader>w',':w<CR>',{desc = "Save",silent = true})
vim.keymap.set('n','<leader>qq',':q!<CR>',{silent = true,desc = "Quit current window"})
vim.keymap.set('n','<leader>qa',':qa!<CR>',{silent = true,desc = "Quit all"})
vim.keymap.set('v','<','<gv')
vim.keymap.set('v','>','>gv')
vim.keymap.set('n','<leader>nh',':nohl<CR>',{silent = true,desc = "No Highlight"})

-- Neo-Tree
vim.keymap.set('n','<leader>ff',":Neotree position=left toggle<CR>",{noremap = true,silent = true,desc = "Open/Close Neo-Tree Filesystem"})
vim.keymap.set('n','<leader>fg',":Neotree position=right git_status toggle<CR>",
              {noremap = true,silent = true,desc = "Open/Close Neo-Tree Git status"})
vim.keymap.set('n','<leader>fb',":Neotree position=bottom buffers toggle<CR>",{noremap = true,silent = true,desc = "Open/Close Neo-Tree Buffers"})

-- Split window
vim.keymap.set('n','<leader>-','<C-w>s',{ desc = "Split window" })
vim.keymap.set('n','<leader>|','<C-w>v',{ desc = "Vertical split window" })
vim.keymap.set('n','<leader>h','<C-w>h',{ desc = "Left window" })
vim.keymap.set('n','<leader>j','<C-w>j',{ desc = "Bottom window" })
vim.keymap.set('n','<leader>k','<C-w>k',{ desc = "Top window" })
vim.keymap.set('n','<leader>l','<C-w>l',{ desc = "Right window" })

-- Heirline
vim.keymap.set('n','<C-h>',':bp<CR>',opt)
vim.keymap.set('n','<C-l>',':bn<CR>',opt)
vim.keymap.set('n','<C-b>',function()Snacks.bufdelete() end,opt)

-- Terminal
vim.keymap.set('n','<leader>t',function()require('snacks.terminal').toggle()end,{ noremap = true,silent = true,desc = "Open Snacks Terminal" })

-- Overseer
vim.keymap.set('n','<leader>r',':OverseerRun<CR>',{ noremap = true,silent = true,desc = "Run Tasks" })

-- Fzflua
vim.keymap.set('n','<leader>fz', function() Snacks.picker.pick() end, {noremap = true,silent = true,desc = "Snacks Picker"})
