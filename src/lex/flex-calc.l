/**
*	
*	Lexical definition of the BoolLanguage. 
*	
*	The file is divided in two parts:
*		- c imports and variables used;
*		- set of regex that identifies keywords and variables of the language.
*
*/

%option noyywrap
%option yylineno
%{

	/*
	*	IMPORTS
	*/
	#include <stdlib.h>
	#include <string.h>

	#include "bool_operations.h"
	#include "symbol_table.h"
	#include "utils.h"

	/*
	*	Root scope of the program is 0. 
	*	Each time a scope in entered, count is increased.
	*	Each time a scope is left behind, count is decreased.
	*/
	int scopeLevel = 0;

	/*
	*	Count used for defining the ID of a scope. ID is unique for each scope.
	*/
	int idCount = 0;
%}


/**
*
*	Set of REGEX used for identifying tokens in the language.
*/
DIGIT    [0-9]
LETTER   [a-zA-Z]
ID       {LETTER}({LETTER}|{DIGIT})*
COMMENT  \/\*([^*]|\n)*\*\/ 
STRING   \"(([^\"]|\\\")*[^\\])?\"

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

{STRING}	{
				yylval.stringVal = formatString( yytext );
				return STRING;
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

yell		{
				return YELL;
			}

{ID}		{
            	char* name = strdup(yytext); 
            	single_symbol* s = initSymbol( name );

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
","			{ return COMMA; }

.           { 
				printf( "Unexpected character: %c\n", yytext[ 0 ] ); return yytext[ 0 ]; 
			}

%%
