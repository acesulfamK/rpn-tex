%{
#include <stdio.h>
%}

DIGIT     [0-9]
WS        [ \t\n]

%%

{DIGIT}+    { printf("NUMBER: %s\n", yytext); }
{WS}        { /* Ignore whitespace */ }
.           { printf("INVALID: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}
