#ifndef H_SCOPE
#define H_SCOPE

#include <stdlib.h>
#include <string.h>

#include "bool_operations.h"
#include "symbol_table.h"

typedef struct {
	int id;							// Unique ID of the scope
	int scopeLevel;					// Distance from the root. Root has a scopeLevel of 0.
	struct single_scope *parent;	// Pointer to the parent scope.
} single_scope;

/*
*	Pointer to the current scope (used in the lexical analysis).
*	Each time a '{' or a '}' is encountered, scope is changed.
*	Reference to the scope.
*/
extern single_scope* current_scope;

/*
*	Flag used for determining whether the first scope has been initialized.
*/
int startingScopeIsInitialized = 0;


/*
*	If single_scope* current_scope has not been initialized yet, a new node is instantiated and becomes the head of the scope structure.
*/
void initScope() {
	if( startingScopeIsInitialized == 0 ) {
		single_scope* ptr = ( single_scope* ) malloc( sizeof( single_scope ) );
		ptr->id = 0;
		ptr->scopeLevel = 0;
		ptr->parent = ( struct single_scope* ) 0;
		current_scope = ptr;
		startingScopeIsInitialized = 1;
	}
}

/*
*	When moving forward the scope, four actions need to be taken:
*		- Create a new scope;
*		- Set the id passed as argument to the new scope;
*		- Assign the current_scope to the parent of the new scope;
*		- Move current_scope pointer to the new scope.
*/
void moveScopeForward( int const id, int const scopeLevel ) {
	initScope();
	single_scope* ptr = ( single_scope* ) malloc( sizeof( single_scope ) );
	ptr->id = id;
	ptr->scopeLevel = scopeLevel;
	ptr->parent = ( struct single_scope* ) current_scope;
	current_scope = ptr;
	single_scope* temp = (single_scope *) current_scope;
}

/*
*	When moving backward the scope, two actions need to be taken:
*		- Set the pointer of the current_scope to his parent;
*		- Free the memory of the scope left behind.
*/
void moveScopeBackward() {
	single_scope* temp = ( single_scope * ) current_scope;
	single_scope* parent = ( single_scope * ) temp->parent;
	current_scope = parent;
}

#endif
