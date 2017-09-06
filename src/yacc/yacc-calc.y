/**
*     
*     Syntactic and semantic definition of the BoolLanguage. 
*     
*     The file is divided in three parts:
*           - c imports;
*           - set of rules that identifies the syntactic part of the language,
*             each one linked to an action that will manage the semantic part;
*           - main method and generic c code (the result of the compiler will be an executable).
*
*/

%{

/*
*     Suppress warnings at compile time.
*/
int yylex();
void yyerror( const char *s );

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

#include "symbol_table.h"
#include "scope.h"
#include "utils.h"

%}

/*
*     Union of all the accepted types that can be returned by a rule. Basically
*     the type of the value of each ID.
*/
%union {
            int booleanVal;               // boolean value, can be either 1 or 0
            single_symbol* symbol;        // type of a symbol
            char* stringVal;              // value of a string 
}

%token <booleanVal>     BOOLEAN
%token <symbol>         ID
%token <stringVal>      STRING
%token                  SEMI AND OR XOR NOT LEFTPAR RIGHTPAR LET ASSIGN LEFTCUR RIGHTCUR YELL COMMA

%type <symbol>          operation

%left OR
%left AND
%left XOR
%right NOT

%start start

%%

start       : scope                       { printSymbolTable(); }
            ;

scope       : statement scope
            | /* empty rule */            
            ;

statement   : LEFTCUR scope RIGHTCUR
            | operation SEMI
            | declaration SEMI
            | instantiation SEMI
            | assignment SEMI
            | print SEMI
            ;

declaration : LET ID                      {
                                               single_symbol* mySym = declareVariable( $2 );
                                               if( mySym == 0 ) {
                                                      char *temp;
                                                      asprintf( &temp, "Variable [%s] is already defined in the current scope", $2->name );
                                                      yyerror( temp );
                                                      YYERROR;
                                               }
                                          }
            ;

instantiation : LET ID ASSIGN operation   {
                                                single_symbol* mySym = declareVariable( $2 );
                                                if( mySym == 0 ) {
                                                      char *temp;
                                                      asprintf( &temp, "Variable [%s] is already defined in the current scope", $2->name );
                                                      yyerror( temp );
                                                      YYERROR;
                                                }
                                                mySym->value = $4->value;
                                                mySym->is_initialized = 1;
                                          }
            ;

assignment  : ID ASSIGN operation         {
                                                single_symbol* mySym =  findSymbol( $1 );
                                                if( mySym == 0 ) {
                                                      char *temp;
                                                      asprintf( &temp, "Variable [%s] has not been declared", $1->name );
                                                      yyerror( temp );
                                                      YYERROR;
                                                }
                                                mySym->value = $3->value;
                                                mySym->is_initialized = 1;
                                          }
            ;

operation   : operation AND operation     { $$ = createUnlinkedSymbol( $1->value && $3->value ); }
            | operation OR operation      { $$ = createUnlinkedSymbol( $1->value || $3->value ); }
            | operation XOR operation     { $$ = createUnlinkedSymbol( $1->value ^ $3->value ); }
            | LEFTPAR operation RIGHTPAR  { $$ = $2; }
            | NOT operation               { $$ = createUnlinkedSymbol( !$2->value ); }
            | ID                          {
                                                single_symbol* mySym =  findSymbol( $1 );
                                                if( mySym == 0 ) {
                                                      char *temp;
                                                      asprintf( &temp, "Variable [%s] has not been declared", $1->name );
                                                      yyerror( temp );
                                                      YYERROR;
                                                }
                                                if( mySym->is_initialized == 0 ) {
                                                      char *temp;
                                                      asprintf( &temp, "Variable [%s] has not been initialized", $1->name );
                                                      yyerror( temp );
                                                      YYERROR;
                                                }
                                                $$ = mySym;
                                          }
            | BOOLEAN                     { $$ = createUnlinkedSymbol( $1 ); }
            ;

print       : YELL LEFTPAR STRING RIGHTPAR     
                                          {
                                                printf( "%s\n", $3 );
                                          }
            | YELL LEFTPAR STRING COMMA STRING RIGHTPAR 
                                          {
                                                printf( "%s%s", computeColor( $3 ), $5 );
                                                printf( "%s", "\e[0m\n" );
                                          }
            | YELL LEFTPAR STRING COMMA operation RIGHTPAR
                                          {
                                                printf( "%s -- ", $3 );
                                                printf( "%s\n", boolToString( $5->value ) );
                                          }
            | YELL LEFTPAR STRING COMMA STRING COMMA operation RIGHTPAR
                                          {
                                                printf( "%s%s -- ", computeColor( $3 ), $5 );
                                                printf( "%s", boolToString( $7->value ) );
                                                printf( "%s", "\e[0m\n" );
                                          }
            ;

%%

#include "lex.yy.c"

single_symbol *symbol_head = 0;
single_scope *current_scope = 0;

extern int yylineno;

void yyerror (char const *message) {
      fprintf(stderr, "\e[91mERROR -> { %s } in line %d.\n", message, yylineno );
}

int main( int argc, char *argv[] ) {
      FILE *fp = fopen( argv[ 1 ], "r" );
      if( !fp ) {
            printf( "Unable to open file for reading\n" );
            exit( 0 );
      }
      yyin = fp;
      int flag = yyparse();
      fclose( yyin );
      
      return flag;
}
