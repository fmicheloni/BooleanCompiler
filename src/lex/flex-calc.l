%option noyywrap
%option yylineno
%{
#include <stdlib.h>
#include <string.h>

#include "bool_operations.h"
#include "symbol_table.h"

int scopeLevel = 0;
int idCount = 0;

%}

DIGIT    [0-9]
LETTER   [a-zA-Z]
ID       {LETTER}({LETTER}|{DIGIT})*
COMMENT  \/\*([^*]|\n)*\*\/ 

%%

[ ]			{
				/* skip blanks */ 
			}

[ \n\t]		{
				/* skip new line*/ 
			}

{COMMENT}	{
				/* skip comment */  
			}

"//"		{
				/* skip comment */
				char c;
				do { 
					c = input();
				} while (c != '\n');
			}

true|false	{
				yylval.booleanVal = parseBool( yytext );
				return BOOLEAN;
			}

let 		{
				return LET;
			}

{ID}		{
            	char* name = strdup(yytext); 
            	singleSymbol* s = initSymbol( name );

				yylval.symbol = s;

				return ID;
			}

"{"			{
				scopeLevel++;
				idCount++;
				moveScopeForward( idCount, scopeLevel );
				return LEFTCUR; 
			}

"}"			{
				moveScopeBackward();
				scopeLevel--;
				return RIGHTCUR; 
			}

"("			{ return LEFTPAR; }
")"			{ return RIGHTPAR; }
";"			{ return SEMI; }
"&&"		{ return AND; }
"||"		{ return OR; }
"^"			{ return XOR; }
"!"			{ return NOT; }
"="			{ return ASSIGN; }

.           { 
				printf( "Unexpected character: %c\n", yytext[ 0 ] ); return yytext[ 0 ]; 
			}

%%
