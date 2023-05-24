#include <stdio.h>
#include "plus.tab.h"

int main()
{
    yyparser();
    const char *inputString = "your input string";
    YY_BUFFER_STATE buffer = yy_scan_string(inputString);
    yyparser();
    yy_delete_buffer(buffer);
}
