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
