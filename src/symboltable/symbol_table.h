#ifndef H_SYMBOL_TABLE
#define H_SYMBOL_TABLE

#include <stdlib.h>
#include <string.h>

#include "bool_operations.h"
#include "scope.h"

typedef struct {
	char *name;						// Name of the symbol.
	int value;						// Value of the current symbol, could be either 0 or 1.
	struct single_symbol *next;  	// Pointer to the next symbol in the current scope.
	int is_initialized;				// Defines whether a variable has been initialized.
	struct single_scope *scope;
} single_symbol;

/*
*	Reference to the scope.
*/
extern single_scope* current_scope;

/*
*	Head of the symbol table.
*/
extern single_symbol* symbol_head;

/**
*	Create a symbol without initializing it.
* 	Declaring variable without instantiating it.
*/
single_symbol* initSymbol( char const *name ) {
	initScope();
	single_symbol* ptr = ( single_symbol* ) malloc ( sizeof ( single_symbol ) );
	ptr->name = ( char* ) malloc ( strlen ( name ) + 1 );
	ptr->is_initialized = 0;
	ptr->scope = ( struct single_scope* ) current_scope;
	strcpy ( ptr->name, name );
	return ptr;
}

/**
*	Set the value of the given symbol with the given value.
*/
void setSymbolValue( single_symbol* s, int value ) {
	s->value = value;
}

/**
*	Insert the given symbol as head of the symbol table.
*/
void insertSymbolInSymbolTable( single_symbol* s ) {
	s->next = ( struct single_symbol* ) symbol_head;
	symbol_head = s;
}

/**
*	Returns a new symbol if in the current scope a variable is declared for the first time.
*	Returns 0 otherwise.
*/
single_symbol* declareVariable( single_symbol* s ) {
	single_scope* declaredVarScope = ( single_scope* ) s->scope;

	single_symbol* ptr;
	for ( ptr = symbol_head; ptr != ( single_symbol * ) 0; ptr = ( single_symbol * ) ptr->next ) {
		single_scope* myScope = ( single_scope* ) ptr->scope;
		if( ( declaredVarScope->id == myScope->id ) && ( strcmp( s->name, ptr->name ) == 0 ) ) {
			return 0;
		}
	}
	insertSymbolInSymbolTable( s );
	return s;
}

/**
*	Find a symbol in the symbol table.
*	The more the scope is close to the scope of the given symbol, the more
*	precedence has to be returned.
*	Returns 0 if a symbol is not found.
*/
single_symbol* findSymbol( single_symbol* s ) {
	single_scope* ptrToScope;
	for ( ptrToScope = ( single_scope * ) s->scope; ptrToScope != ( single_scope * ) 0; ptrToScope = ( single_scope * ) ptrToScope->parent ) {
		single_symbol* ptrToSymbol;
		for ( ptrToSymbol = symbol_head; ptrToSymbol != ( single_symbol * ) 0; ptrToSymbol = ( single_symbol * ) ptrToSymbol->next ) {
			single_scope* currentSymbolScope = ( single_scope * ) ptrToSymbol->scope;
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
single_symbol* createUnlinkedSymbol( int const input_value ) {
	single_symbol* unbound = initSymbol( "unlinked_var" );
	unbound->is_initialized = 1;
	unbound->value = input_value;
	return unbound;
}

/**
*	Method that prints the symbol table to the screen in the following format:
*	--------------------------------------------
*	| NAME   | VALUE     | SC_ID   | SC_LEVEL  |
*	--------------------------------------------
*	...
*/
void printSymbolTable() {
	single_symbol* ptr;
	printf( "--------------------------------------------\n" );
	printf( "| \e[0;34mNAME\e[0m   | \e[0;34mVALUE\e[0m     | \e[0;34mSC_ID\e[0m   | \e[0;34mSC_LEVEL\e[0m  |\n" );
	printf( "--------------------------------------------\n" );
	for ( ptr = symbol_head; ptr != ( single_symbol * ) 0; ptr = ( single_symbol * ) ptr->next ) {
		single_scope* currentSymbolScope = ( single_scope * ) ptr->scope;
		printf( "| %-7.7s| %-10.10s| %-8d| %-10d|\n", 
						ptr->name, 
						( ptr->is_initialized ) ? boolToString( ptr->value ) : "not init", 
						currentSymbolScope->id,
						currentSymbolScope->scopeLevel );
	}
	printf( "--------------------------------------------\n" );
}

#endif
