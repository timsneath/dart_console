#include <stdlib.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
    printf("On this platform, TIOCGWINSZ is 0x%lx\n", TIOCGWINSZ);
    printf("On this platform, TIOCSTI is 0x%lx\n", TIOCSTI);

    printf("sizeof(tcflag_t) is %lu\n", sizeof(tcflag_t));
    printf("sizeof(cc_t) is %lu\n", sizeof(cc_t));
    printf("sizeof(speed_t) is %lu\n", sizeof(speed_t));
}