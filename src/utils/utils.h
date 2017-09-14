#ifndef H_UTILS
#define H_UTILS

#include <stdlib.h>
#include <string.h>

char* formatString( char* str ) {
	char *p = str;
	p++;
	p[ strlen( p ) -1 ] = 0;
	return p;
}

char* computeColor( char* str ) {
	if( strcmp( str, "red" ) == 0 ) {
		return "\e[91m";
	}
	if( strcmp( str, "blue" ) == 0 ) {
		return "\e[0;34m";
	}
	if( strcmp( str, "green" ) == 0 ) {
		return "\e[32m";
	}
	return "";
}

#endif