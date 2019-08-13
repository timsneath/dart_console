#include <windows.h>
#include <stdio.h>
// BOOL WINAPI GetConsoleScreenBufferInfoEx(
//     _In_ HANDLE hConsoleOutput,
//     _Out_ PCONSOLE_SCREEN_BUFFER_INFOEX lpConsoleScreenBufferInfoEx);

// typedef struct _CONSOLE_SCREEN_BUFFER_INFOEX
// {
//     ULONG cbSize;
//     COORD dwSize;
//     COORD dwCursorPosition;
//     WORD wAttributes;
//     SMALL_RECT srWindow;
//     COORD dwMaximumWindowSize;
//     WORD wPopupAttributes;
//     BOOL bFullscreenSupported;
//     COLORREF ColorTable[16];
// } CONSOLE_SCREEN_BUFFER_INFOEX, *PCONSOLE_SCREEN_BUFFER_INFOEX;

void main()
{
    printf("On this platform:\n");
    printf("sizeof(char) is %lu\n", sizeof(char));
    printf("sizeof(SHORT) is %lu\n", sizeof(SHORT));
    printf("sizeof(WORD) is %lu\n", sizeof(WORD));
    printf("sizeof(DWORD) is %lu\n", sizeof(DWORD));
    printf("sizeof(ULONG) is %lu\n\n", sizeof(ULONG));

    printf("sizeof(COORD) is %lu\n", sizeof(COORD));
    printf("sizeof(SMALL_RECT) is %lu\n", sizeof(SMALL_RECT));
    printf("sizeof(COLORREF) is %lu\n", sizeof(COLORREF));
}