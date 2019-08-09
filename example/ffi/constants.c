#include <stdlib.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>

int main()
{
    printf("On this platform:\n");
    printf("TIOCGWINSZ is 0x%lx\n", TIOCGWINSZ);
    printf("TIOCSTI is 0x%lx\n\n", TIOCSTI);

    printf("sizeof(char) is %lu\n", sizeof(char));
    printf("sizeof(short) is %lu\n", sizeof(short));
    printf("sizeof(int) is %lu\n", sizeof(int));
    printf("sizeof(long) is %lu\n\n", sizeof(long));

    printf("sizeof(tcflag_t) is %lu\n", sizeof(tcflag_t));
    printf("sizeof(cc_t) is %lu\n", sizeof(cc_t));
    printf("sizeof(speed_t) is %lu\n", sizeof(speed_t));
}