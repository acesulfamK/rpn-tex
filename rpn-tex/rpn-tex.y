%code top {
  #include <assert.h>
  #include <ctype.h>  /* isdigit. */
  #include <stdio.h>  /* printf. */
  #include <stdlib.h> /* abort. */
  #include <string.h> /* strcmp. */

  int yylex (void);
  void yyerror (char const *);
}


/* Generate YYSTYPE from the types used in %token and %type.  */
%define api.value.type union
%token <char*> STRING "string"
%token FRAC
%token INT
%type  <char*> expr 

/* Generate the parser description file (calc.output).  */
%verbose

/* Nice error messages with details. */
%define parse.error detailed

/* Enable run-time traces (yydebug).  */
%define parse.trace

/* Formatting semantic values in debug traces.  */
%printer { fprintf (yyo, "%s", $$); } <char*>;

%% /* The grammar follows.  */
input:
  %empty
| input line
;

line:
'\n'
| expr '\n'  { printf ("%s\n", $1); }
| error '\n' { yyerrok; }
;

expr: "string"

  | expr expr FRAC
  {
  char * new_string = (char*)malloc(strlen($1) + strlen($2) + 10);
  strcpy(new_string, "\\frac");
  strcat(new_string, "{");
  strcat(new_string, $1);
  strcat(new_string, "}{");
  strcat(new_string, $2);
  strcat(new_string, "}");
  $$ = new_string;
  free($1);
  free($2);
  }

  | expr expr '^'
  {
  char * new_string = (char*)malloc(strlen($1) + strlen($2) + 4);
  strcpy(new_string, $1);
  strcat(new_string, "^");
  strcat(new_string, "{");
  strcat(new_string, $2);
  strcat(new_string, "}");
  $$ = new_string;
  free($1);
  free($2);
  }

  | expr expr '_'
  {
  char * new_string = (char*)malloc(strlen($1) + strlen($2) + 4);
  strcpy(new_string, $1);
  strcat(new_string, "_");
  strcat(new_string, "{");
  strcat(new_string, $2);
  strcat(new_string, "}");
  $$ = new_string;
  free($1);
  free($2);
  }

  | expr expr '&'
  {
  char * new_string = (char*)malloc(strlen($1) + strlen($2) + 1);
  strcpy(new_string, $1);
  strcat(new_string, $2);
  $$ = new_string;
  free($1);
  free($2);
  }

  | expr ')'
  {
  char * new_string = (char*)malloc(strlen($1) + 3);
  strcpy(new_string, "(");
  strcat(new_string, $1);
  strcat(new_string, ")");
  $$ = new_string;
  free($1);
  }

  | INT
  {
    char * new_string = (char*)malloc(5);
    strcpy(new_string,"\\int");
    $$ = new_string;
  }
;

%%

int yylex() {
  int c;

  while ((c = getchar ()) == ' ' || c == '\t')
    continue;
  
  if (c == EOF) {
      return 0;
  } else if (c == '+') {
      return '+';
  } else if (c == '\n') {
      return '\n';
  } else if (c == '@'){
    switch(c = getchar()){
      case 'f': return FRAC;
      case 'i': return INT;
      fprintf(stderr, "Error: A character after '@' is nonexpected.\n");
      exit(1);
    }
  } else {
      switch(c){
        case '_':
        case '^':
        case '&':
        case ')':
        return c;
      }
      ungetc(c, stdin);
      char* buffer = (char*)malloc(256);
      int i = 0;
      while ((c = getchar()) != EOF && c != '\n' && c != ' ' && c != '\t'){
          buffer[i++] = c;
      }
      // prevent double Enter push
      if(c == '\n'){ 
        ungetc(c,stdin);
      }
      
      buffer[i] = '\0';
      yylval.STRING = buffer;
      return STRING;
  }
}

/* Called by yyparse on error.  */
void
yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

int
main (int argc, char const* argv[])
{
  /* Enable parse traces on option -p.  */
  for (int i = 1; i < argc; ++i)
    if (!strcmp (argv[i], "-p"))
      yydebug = 1;
  return yyparse ();
}
