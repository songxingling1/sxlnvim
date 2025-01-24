# WARN
**IN THIS REPONSITORY THERE IS A `consolepauser.cpp` .PLEASE COMPILE THIS FILE AS `consolepauser` AND ADD IT TO THE SYSTEM PATH!!!**
# sxlnvim
SXL's Neovim!

# Extensions List
- [blink.cmp](https://github.com/Saghen/blink.cmp)
- [diffview.nvim](https://github.com/sindrets/diffview.nvim)
- [edgy.nvim](https://github.com/folke/edgy.nvim)
- [friendly-snippets](https://github.com/sar/friendly-snippets.nvim)
- [grug-far.nvim](https://github.com/MagicDuck/grug-far.nvim)
- [heirline.nvim](https://github.com/rebelot/heirline.nvim)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [marklive.nvim](https://github.com/yelog/marklive.nvim)
- [mini.nvim](https://github.com/echasnovski/mini.nvim)
    - mini.ai
    - mini.icons
    - mini.move
    - mini.pairs
    - mini.surround
- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [neogit](https://github.com/NeogitOrg/neogit)
- [noice.nvim](https://github.com/folke/noice.nvim)
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim)
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)
- [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [vim-navic](https://github.com/SmiteshP/nvim-navic)
- [nvim-nio](https://github.com/nvim-neotest/nvim-nio)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)
- [nvim-window](https://github.com/yorickpeterse/nvim-window)
- [overseer.nvim](https://github.com/stevearc/overseer.nvim)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [rainbow-delimiters](https://github.com/hiphish/rainbow-delimiters.nvim)
- [snacks.nvim](https://github.com/folke/snacks.nvim)
    - dashboard
    - picker
    - indent
    - input
    - notifier
    - quickfile
    - scroll
    - statuscolumn
    - words
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- [trouble.nvim](https://github.com/folke/trouble.nvim)
- [vim-suda](https://github.com/lambdalisue/vim-suda)
- [which-key.nvim](https://github.com/folke/which-key.nvim)
- [yazi.nvim](https://github.com/mikavilpas/yazi.nvim)

# Consolepauser
This tool resolves conflicts between overseer.nvim and nvim-dap.
```cpp
#include <csignal>
#include <cstdio>
#include <cstring>
#include <string>
#include <termios.h>
using namespace std;
int getch() {
    struct termios tm,tm_old;
    int fd = STDIN_FILENO,c;
    if(tcgetattr(fd, &tm) < 0) {
        return -1;
    }
    tm_old = tm;
    cfmakeraw(&tm);
    if(tcsetattr(fd, TCSANOW, &tm) < 0) {
        return -1;
    }
    c = fgetc(stdin);
    if(tcsetattr(fd, TCSANOW, &tm_old) < 0) {
        return -1;
    }
    return c;
}
int main(int argc,char *argv[]) {
    if(argc < 2) {
        printf("Usage: command [PROGRAM] [OPTIONS]\n");
        return 0;
    }
    string cmd = "(/usr/bin/time -v";
    for(int i = 1;i < argc;i++) {
        cmd = cmd + " " + string(argv[i]);
    }
    cmd = cmd + ") 2> /tmp/consolepauser-time.log";
    unsigned int status = system(cmd.c_str());
    FILE *fp = fopen("/tmp/consolepauser-time.log", "r");
    char buffer[512];
    int memory = -1;
    char *time = nullptr;
    while(fgets(buffer,512,fp) != NULL) {
        if(strncmp(buffer, "\tMaximum resident set size (kbytes):", 36) == 0) {
            memory = atoi(buffer + 36);
        }
        if(strncmp(buffer, "\tElapsed (wall clock) time (h:mm:ss or m:ss):", 45) == 0) {
            time = strdup(buffer + 46);
        }
    }
    printf("Running time(h:mm:ss or m:ss) : %s",time);
    printf("Running memory(MB) : %f\n",memory * 1.0 / 1024);
    printf("Exit code : %u (0x%X)\n",status,status);
    printf("Please press any key to continue...");
    getch();
    puts("");
    delete time;
    return status;
}
```
**Compile this file as `consolepauser` and add it to the system PATH!!!**

# Screenshot
