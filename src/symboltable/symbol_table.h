#ifndef H_SYMBOL_TABLE
#define H_SYMBOL_TABLE

#include <stdlib.h>
#include <string.h>

#include "bool_operations.h"
#include "scope.h"

////////////////////////////////////////////
//                  SYMBOL                //
////////////////////////////////////////////

typedef struct {
	char *name;						// Name of the symbol.
	int value;						// Value of the current symbol, could be either 0 or 1.
	struct singleSymbol *next;  	// Pointer to the next symbol in the current scope.
	int is_initialized;				// Defines whether a variable has been initialized.
	struct singleScope *scope;
} singleSymbol;

/*
*
*
*/
extern singleScope* currentScope;

/*
*
*	SYMBOL_TABLE METHODS AND INSTANCES
*
*/
extern singleSymbol* symbol;

/**
*	Create a symbol without initializing it.
* 	Declaring variable without instantiating it.
*/
singleSymbol* initSymbol( char const *name ) {
	initScope();
	singleSymbol* ptr = ( singleSymbol* ) malloc ( sizeof ( singleSymbol ) );
	ptr->name = ( char* ) malloc ( strlen ( name ) + 1 );
	ptr->is_initialized = 0;
	ptr->scope = ( struct singleScope* ) currentScope;
	strcpy ( ptr->name, name );
	return ptr;
}

void setSymbolValue( singleSymbol* s, int value ) {
	s->value = value;
}

void insertSymbolInSymbolTable( singleSymbol* s ) {
	s->next = ( struct singleSymbol* ) symbol;
	symbol = s;
}

singleSymbol* declareVariable( singleSymbol* s ) {
	singleScope* declaredVarScope = ( singleScope* ) s->scope;

	singleSymbol* ptr;
	for ( ptr = symbol; ptr != ( singleSymbol * ) 0; ptr = ( singleSymbol * ) ptr->next ) {
		singleScope* myScope = ( singleScope* ) ptr->scope;
		if( ( declaredVarScope->id == myScope->id ) && ( strcmp( s->name, ptr->name ) == 0 ) ) {
			return 0;
		}
	}
	insertSymbolInSymbolTable( s );
	return s;
}

singleSymbol* findSymbol( singleSymbol* s ) {
	singleScope* ptrToScope;
	for ( ptrToScope = ( singleScope * ) s->scope; ptrToScope != ( singleScope * ) 0; ptrToScope = ( singleScope * ) ptrToScope->parent ) {
		singleSymbol* ptrToSymbol;
		for ( ptrToSymbol = symbol; ptrToSymbol != ( singleSymbol * ) 0; ptrToSymbol = ( singleSymbol * ) ptrToSymbol->next ) {
			singleScope* currentSymbolScope = ( singleScope * ) ptrToSymbol->scope;
			if( ( ptrToScope->id == currentSymbolScope->id ) && ( strcmp( s->name, ptrToSymbol->name ) == 0 ) ) {
				return ptrToSymbol;
			}
		}
	}
	return 0;
}

/*
*	Create a symbol giving it a value, used for unbounded variables.
*	Used for VALUEs, not for IDs.
*/
singleSymbol* createUnlinkedSymbol( int const input_value ) {
	singleSymbol* unbound = initSymbol( "unlinked_var" );
	unbound->is_initialized = 1;
	unbound->value = input_value;
	return unbound;
}

void printSymbolTable() {
	singleSymbol* ptr;
	printf( "--------------------------------------------\n" );
	printf( "| \e[0;34mNAME\e[0m   | \e[0;34mVALUE\e[0m     | \e[0;34mSC_ID\e[0m   | \e[0;34mSC_LEVEL\e[0m  |\n" );
	printf( "--------------------------------------------\n" );
	for ( ptr = symbol; ptr != ( singleSymbol * ) 0; ptr = ( singleSymbol * ) ptr->next ) {
		singleScope* currentSymbolScope = ( singleScope * ) ptr->scope;
		printf( "| %-7.7s| %-10.10s| %-8d| %-10d|\n", 
						ptr->name, 
						( ptr->is_initialized ) ? boolToString( ptr->value ) : "not init", 
						currentSymbolScope->id,
						currentSymbolScope->scopeLevel );
	}
	printf( "--------------------------------------------\n" );
}

#endif
