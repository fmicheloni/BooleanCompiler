%{

int yylex();
void yyerror( const char *s );

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

#include "symbol_table.h"
#include "scope.h"
%}


%union {
            int booleanVal;               // boolean value
            singleSymbol* symbol;         // type of a symbol
       }

%token <booleanVal>     BOOLEAN
%token <symbol>         ID
%token                  SEMI
%token                  AND
%token                  OR
%token                  XOR
%token                  NOT
%token                  LEFTPAR
%token                  RIGHTPAR
%token                  LET
%token                  ASSIGN
%token                  LEFTCUR
%token                  RIGHTCUR

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
            | operation SEMI              { printf( "\e[32mRESULT: %d\e[0m\n", $1->value ); }
            | declaration SEMI
            | instantiation SEMI
            | assignment SEMI
            ;

declaration : LET ID                      {
                                               singleSymbol* mySym = declareVariable( $2 );
                                               if( mySym == 0 ) {
                                                      char *temp;
                                                      asprintf( &temp, "Variable [%s] is already defined in the current scope", $2->name );
                                                      yyerror( temp );
                                                      YYERROR;
                                               }
                                          }
            ;

instantiation : LET ID ASSIGN operation   {
                                                singleSymbol* mySym = declareVariable( $2 );
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
                                                singleSymbol* mySym =  findSymbol( $1 );
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
                                                singleSymbol* mySym =  findSymbol( $1 );
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

%%

#include "lex.yy.c"

singleSymbol *symbol = 0;
singleScope *currentScope = 0;

extern int yylineno;

void yyerror (char const *message) {
      fprintf(stderr, "\e[91mERROR -> { %s } in line %d.\n", message, yylineno );
}

int main( int argc, char *argv[] ) {
      FILE *fp = fopen( argv[1], "r" );
      if(!fp) 
      {
            printf( "Unable to open file for reading\n" );
            exit( 0 );
      }
      yyin = fp;
      int flag = yyparse();
      fclose( yyin );
      
      return flag;
}
