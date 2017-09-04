%{
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

#include "y.tab.h"

void yyerror(char *s);

%}

%union {
	char* lexeme;
	int value;
}

%token	<lexeme>	ID
%token 				OR 
%token 				AND 
%token 				XOR 
%token 				NOT 
%token 				ASSIGN
%token 				LP 
%token				RP 
%token				LCB 
%token				RCB 
%token				SEMI
%token 				LET
%token 	<value>		VALUE

%type 			   	statement 
%type 				start

%left OR
%left AND
%left XOR
%right NOT

%start start

%%

start		: LP   	{ printf( "yo" ); return; }
			;



%%

#include "lex.yy.c"

int main( int argc, char *argv[] ) 
{    
	FILE *fp = fopen( argv[1],"r" );
	if( !fp ) {
		printf( "Unable to open file for reading\n" );
		exit( 0 );
	}
	yyin = fp;
	int flag = yyparse();
	fclose(yyin);
	
	return flag;
}

void yyerror ( char *s ) {
	fprintf( stderr, "%s\n", s );
	exit( 1 );
}
