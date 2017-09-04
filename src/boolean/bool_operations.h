#ifndef H_BOOL_OPERATIONS
#define H_BOOL_OPERATIONS

#include <stdbool.h>

bool parseBool( char inputBool[] ) {
	if( strcmp( inputBool, "false" ) == 0 ) {
		return 0;
	} else {
		return 1;
	}
	
}

const char* boolToString( int inputBool ) {
	if( inputBool == 0 ) {
		return "false";
	} else {
		return "true";
	}
}

#endif
