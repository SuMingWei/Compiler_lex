/* Definition section */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define YY_NO_UNPUT
    #define YY_NO_INPUT

    int line_num = 0;
    int comment_num = 0;
%}



/* Define regular expression label */
letter [a-zA-Z_]
digit [0-9]
id {letter}+({letter}|{digit})* 
inumber {digit}+
fnumber ({digit}*\.{digit}+)
string ([^\n\t\"]|"\\\"")*

space [ \t]
newline [\n]

%x STRING
%x C_COMMENT
%x CPP_COMMENT

/* keyword */
PRINT print
RETURN return
IF if
ELSE else
FOR for
WHILE while
INT int
FLOAT float
STRING string
BOOL bool
TRUE true
FALSE false
CONTINUE continue
BREAK break
VOID void

/* Rules section */
%%

"+"          { printf("%-8s \t %s\n", yytext, "ADD"); }
"-"          { printf("%-8s \t %s\n", yytext, "SUB"); }
"*"          { printf("%-8s \t %s\n", yytext, "MUL"); }
"/"          { printf("%-8s \t %s\n", yytext, "QUO"); }
"%"          { printf("%-8s \t %s\n", yytext, "REM"); }
"++"         { printf("%-8s \t %s\n", yytext, "INC"); }
"--"         { printf("%-8s \t %s\n", yytext, "DEC"); }
">"          { printf("%-8s \t %s\n", yytext, "GTR"); }
"<"          { printf("%-8s \t %s\n", yytext, "LSS"); }
">="         { printf("%-8s \t %s\n", yytext, "GEQ"); }
"<="         { printf("%-8s \t %s\n", yytext, "LEQ"); }
"=="         { printf("%-8s \t %s\n", yytext, "EQL"); }
"!="         { printf("%-8s \t %s\n", yytext, "NEQ"); }
"="          { printf("%-8s \t %s\n", yytext, "ASSIGN"); }
"+="         { printf("%-8s \t %s\n", yytext, "ADD_ASSIGN"); }
"-="         { printf("%-8s \t %s\n", yytext, "SUB_ASSIGN"); }
"*="         { printf("%-8s \t %s\n", yytext, "MUL_ASSIGN"); }
"/="         { printf("%-8s \t %s\n", yytext, "QUO_ASSIGN"); }
"%="         { printf("%-8s \t %s\n", yytext, "REM_ASSIGN"); }

"&&"         { printf("%-8s \t %s\n", yytext, "AND"); }
"||"         { printf("%-8s \t %s\n", yytext, "OR"); }
"!"          { printf("%-8s \t %s\n", yytext, "NOT"); }
"("          { printf("%-8s \t %s\n", yytext, "LPAREN"); }
")"          { printf("%-8s \t %s\n", yytext, "RPAREN"); }
"["          { printf("%-8s \t %s\n", yytext, "LBARCK"); }
"]"          { printf("%-8s \t %s\n", yytext, "RBARCK"); }
"{"          { printf("%-8s \t %s\n", yytext, "LBRACE"); }
"}"          { printf("%-8s \t %s\n", yytext, "RBRACE"); }
";"          { printf("%-8s \t %s\n", yytext, "SEMICOLON"); }
","          { printf("%-8s \t %s\n", yytext, "COMMA"); }


{PRINT}         { printf("%-8s \t %s\n", yytext, "PRINT"); }
{RETURN}        { printf("%-8s \t %s\n", yytext, "RETURN"); }
{IF}            { printf("%-8s \t %s\n", yytext, "IF"); }
{ELSE}          { printf("%-8s \t %s\n", yytext, "ELSE"); }
{FOR}           { printf("%-8s \t %s\n", yytext, "FOR"); }
{WHILE}         { printf("%-8s \t %s\n", yytext, "WHILE"); }
{INT}           { printf("%-8s \t %s\n", yytext, "INT"); }
{FLOAT}         { printf("%-8s \t %s\n", yytext, "FLOAT"); }
{STRING}        { printf("%-8s \t %s\n", yytext, "STRING"); }
{BOOL}          { printf("%-8s \t %s\n", yytext, "BOOL"); }
{TRUE}          { printf("%-8s \t %s\n", yytext, "TRUE"); }
{FALSE}         { printf("%-8s \t %s\n", yytext, "FALSE"); }
{CONTINUE}      { printf("%-8s \t %s\n", yytext, "CONTINUE"); }
{BREAK}         { printf("%-8s \t %s\n", yytext, "BREAK"); }
{VOID}          { printf("%-8s \t %s\n", yytext, "VOID"); }

{space}         {;}
{newline}       {line_num++;}

{inumber}       { printf("%-8s \t %s\n", yytext, "INT_LIT"); }
{fnumber}       { printf("%-8s \t %s\n", yytext, "FLOAT_LIT"); }
{id}            { printf("%-8s \t %s\n", yytext, "IDENT"); }

"//"              { BEGIN CPP_COMMENT; printf("%s", yytext);}
<CPP_COMMENT>\n   { BEGIN INITIAL; 
                    line_num++;
                    comment_num++;
                    printf(" \t %s\n", "C++ Comment");}
<CPP_COMMENT>.    { printf("%s", yytext);}

"/*"              { BEGIN C_COMMENT; printf("%s", yytext);}
<C_COMMENT>"*/"   { BEGIN INITIAL; 
                    comment_num++;
                    printf("%s \t %s\n", "*/", "C Comment");}
<C_COMMENT>\n     { comment_num++;
                    line_num++;
                    printf(" \t %s\n", "C Comment");}
<C_COMMENT>.      { printf("%s", yytext);}

\"                { BEGIN STRING; printf("%-8s \t %s\n", yytext, "QUOTA");}
<STRING>\"        { BEGIN INITIAL; 
                    printf("%-8s \t %s\n", yytext, "QUOTA");}
<STRING>{string}  { printf("%-8s \t %s\n", yytext, "STRING_LIT");}

<<EOF>>     { line_num++; yyterminate(); }
.           {;}

%%

/*  C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc, char *argv[])
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    yylex();
    printf("\nFinish scanning,\n");
    printf("total line: %d\n", line_num);
    printf("comment line: %d\n", comment_num);
    fclose(yyin);
    return 0;
}
