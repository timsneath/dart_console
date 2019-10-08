#include <stdlib.h>
#include <windows.h>
#include <stdio.h>

int main()
{
    printf("On this platform:\n");
    printf("STD_INPUT_HANDLE is %d\n", STD_INPUT_HANDLE);
    printf("STD_OUTPUT_HANDLE is %d\n", STD_OUTPUT_HANDLE);
    printf("STD_ERROR_HANDLE is %d\n", STD_ERROR_HANDLE);

    printf("STATUS_INVALID_PARAMETER is %X\n", STATUS_INVALID_PARAMETER);

    printf("sizeof(COORD) is %lu\n", sizeof(COORD));
    printf("sizeof(SMALL_RECT) is %lu\n", sizeof(SMALL_RECT));
    printf("sizeof(HANDLE) is %lu\n", sizeof(HANDLE));
    printf("sizeof(CONSOLE_CURSOR_INFO) is %lu\n", sizeof(CONSOLE_CURSOR_INFO));

    printf("sizeof(TCHAR) is %lu\n", sizeof(TCHAR));
    printf("sizeof(DWORD) is %lu\n", sizeof(DWORD));
    printf("sizeof(WORD) is %lu\n", sizeof(WORD));
    printf("sizeof(SHORT) is %lu\n", sizeof(SHORT));
    printf("sizeof(BOOL) is %lu\n", sizeof(BOOL));
}