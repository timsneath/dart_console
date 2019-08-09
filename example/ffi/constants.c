#include <stdlib.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
    printf("On this platform, TIOCGWINSZ is 0x%lx\n", TIOCGWINSZ);
    printf("On this platform, TIOCSTI is 0x%lx\n", TIOCSTI);
}