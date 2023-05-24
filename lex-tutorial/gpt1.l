%{
#include <stdio.h>
%}

%option noyywrap
%option yylineno

%%
[a-zA-Z_][a-zA-Z0-9_]*   { printf("Identifier: %s\n", yytext); }
.                        { /* 何もしない */ }
%%

int main() {
    char* input_string = "This is a test string.";

    yy_scan_string(input_string);
    yylex();

    return 0;
}
