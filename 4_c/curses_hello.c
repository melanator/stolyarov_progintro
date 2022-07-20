#include <curses.h>
#include <unistd.h>

const char message[] = "Hello, world!";
enum { delay_duration = 5 };

int main()
{
    int row, col;
    initscr();
    getmaxyx(stdscr, row, col);
    move(row/2, (col-(sizeof(message) - 1))/2);
    curs_set(0);
    refresh();
    sleep(delay_duration);
    endwin();
    return 0;
}