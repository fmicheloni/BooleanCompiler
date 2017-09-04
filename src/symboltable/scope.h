#ifndef H_SCOPE
#define H_SCOPE

#include <stdlib.h>
#include <string.h>

#include "bool_operations.h"
#include "symbol_table.h"

typedef struct {
	int id;
	int scopeLevel;
	struct singleScope *parent;
} singleScope;

/*
*
*	SCOPE METHODS AND INSTANCES
*
*/
extern singleScope* currentScope;

/*
*	Flag used for determining whether the first scope has been initialized.
*/
int startingScopeIsInitialized = 0;


/*
*	If singleScope* currentScope has not been initialized yet, a new node is instantiated and becomes the head of the scope structure.
*/
void initScope() {
	if( startingScopeIsInitialized == 0 ) {
		singleScope* ptr = ( singleScope* ) malloc( sizeof( singleScope ) );
		ptr->id = 0;
		ptr->scopeLevel = 0;
		ptr->parent = ( struct singleScope* ) 0;
		currentScope = ptr;
		startingScopeIsInitialized = 1;
	}
}

/*
*
*	When moving forward the scope, four actions need to be taken:
*		- Create a new scope;
*		- Set the id passed as argument to the new scope;
*		- Assign the currentScope to the parent of the new scope;
*		- Move currentScope pointer to the new scope.
*
*/
void moveScopeForward( int const id, int const scopeLevel ) {
	initScope();
	singleScope* ptr = ( singleScope* ) malloc( sizeof( singleScope ) );
	ptr->id = id;
	ptr->scopeLevel = scopeLevel;
	ptr->parent = ( struct singleScope* ) currentScope;
	currentScope = ptr;
	singleScope* temp = (singleScope *) currentScope;
}

/*
*
*	When moving backward the scope, two actions need to be taken:
*		- Set the pointer of the currentScope to his parent;
*		- Free the memory of the scope left behind.
*
*/
void moveScopeBackward() {
	singleScope* temp = ( singleScope * ) currentScope;
	singleScope* parent = ( singleScope * ) temp->parent;
	currentScope = parent;
}

#endif
