// #define _CRT_SECURE_NO_WARNINGS

#include <windows.h>

#define NEW_WIDTH 100
#define NEW_HEIGHT 50

void error(const char *txt)
{

    char msg[200];

    //
    //   StringCbPrintf should be used… however, I was unable
    //   to link it without CRT.
    //   StringCbPrintf(msg, 200, "%s: %d", txt, GetLastError());
    //
    wsprintfA(msg, "%s: %d", txt, GetLastError());

    MessageBox(NULL, msg, "Error", 0);
}

int __stdcall go(void)
{

    HANDLE orig_con_h;
    HANDLE repl_con_h;

    CONSOLE_SCREEN_BUFFER_INFOEX orig_con_info;

    COORD repl_con_buf_size;
    SMALL_RECT repl_con_screen;

    COORD cursor_pos;

    orig_con_h = GetStdHandle(STD_OUTPUT_HANDLE);

    orig_con_info.cbSize = sizeof(orig_con_info);

    if (!GetConsoleScreenBufferInfoEx(orig_con_h, &orig_con_info))
    {
        MessageBox(NULL, "GetConsoleScreenBufferInfoEx", "Error", 0);
        return 1;
    }

    //
    // Check if we're able to create a console that fits
    // our desired size:
    //
    if (NEW_WIDTH > orig_con_info.dwMaximumWindowSize.X ||
        NEW_HEIGHT > orig_con_info.dwMaximumWindowSize.Y)
    {

        MessageBox(NULL, "Requested width or height too large", "Error", 0);
        goto back_to_orig_console;
    }

    repl_con_h = CreateConsoleScreenBuffer(GENERIC_READ | GENERIC_WRITE, 0, NULL, CONSOLE_TEXTMODE_BUFFER, NULL);

    if (repl_con_h == INVALID_HANDLE_VALUE)
    {
        error("CreateConsoleScreenBuffer");
        goto back_to_orig_console;
    }

    //
    // Switch to the »new« console
    //

    SetConsoleActiveScreenBuffer(repl_con_h);

    //
    // Change the new console's size
    //

    repl_con_screen.Left = 0;
    repl_con_screen.Top = 0;
    repl_con_screen.Right = NEW_WIDTH - 1;
    repl_con_screen.Bottom = NEW_HEIGHT - 1;

    if (!SetConsoleWindowInfo(repl_con_h, TRUE, &repl_con_screen))
    {
        error("SetConsoleWindowInfo");
        // goto back_to_orig_console;
    }

    //
    // Change the new console's buffer size.
    //

    repl_con_buf_size.X = NEW_WIDTH;
    repl_con_buf_size.Y = NEW_HEIGHT;

    if (!SetConsoleScreenBufferSize(repl_con_h, repl_con_buf_size))
    {
        error("SetConsoleScreenBufferSize");
        // goto back_to_orig_console;
    }

    //
    // Show rudimentary coordinate system
    //

    for (cursor_pos.X = 10; cursor_pos.X < NEW_WIDTH; cursor_pos.X += 10)
    {
        for (cursor_pos.Y = 0; cursor_pos.Y < NEW_HEIGHT; cursor_pos.Y++)
        {

            if (!SetConsoleCursorPosition(repl_con_h, cursor_pos))
            {
                error("SetConsoleCursorPosition");
                goto back_to_orig_console;
            }

            WriteConsole(repl_con_h, &"0123456789"[cursor_pos.Y % 10], 1, NULL, NULL);
        }
    }

    for (cursor_pos.Y = 10; cursor_pos.Y < NEW_HEIGHT; cursor_pos.Y += 10)
    {
        for (cursor_pos.X = 0; cursor_pos.X < NEW_WIDTH; cursor_pos.X++)
        {

            if (!SetConsoleCursorPosition(repl_con_h, cursor_pos))
            {
                error("SetConsoleCursorPosition");
                goto back_to_orig_console;
            }

            WriteConsole(repl_con_h, &"0123456789"[cursor_pos.X % 10], 1, NULL, NULL);
        }
    }

    //
    // Wait until the user chooses to quit the app.
    //
    MessageBoxA(0, "Finish app", "resize", MB_OK);

    //
    // Go back to original console
    //
back_to_orig_console:

    SetConsoleScreenBufferInfoEx(orig_con_h, &orig_con_info);
    SetConsoleActiveScreenBuffer(orig_con_h);

    return 0;
};