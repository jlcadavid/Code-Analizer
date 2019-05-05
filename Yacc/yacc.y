%{
void yyerror (char *s)
#include <stdio.h>
#include <stdlib.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}

%union {int mInt; float mDouble; char mChar[]; bool mBool;}
%start mProgram
%token mLibrary
%token VOID
%token MAIN
%token PRINT
%token SCAN
%token ARGS
%token RETURN

%token IF
%token ELSE
%token WHILE
%token DO
%token FOR
%token SWITCH
%token CASE
%token DEFAULT
%token BREAK

%token PRIMITIVE
%token ID
%token CTE_INT
%token CTE_FLOAT
%token CTE_STRING
%token CTE_BOOL

%token OP_AND
%token OP_OR
%token OP_EQ
%token OP_NEQ
%token OP_LEQ
%token OP_GEQ
%token OP_INCREMENT 
%token OP_DECREMENT

%token '='
%token '('
%token ')'
%token '*'
%token '+'
%token '-'
%token '/'
%token '^'
%token '%'
%token '!'
%token '>'
%token '<'
%token '{'
%token '}'
%token ';'
%token ','

%%

/* DESCRIPTIONS OF EXPECTED INPUTS		CORRESPONDING ACTIONS (IN C) */

mProgram	: mLibraries mOpDeclarations mFunctions
		| mDeclarations mFunctions
		;

mDeclaration	: mType mID '=' mDecList ';';

mOpDeclarations : /* NULL */
		| mDeclarations
		;

mDeclarations	: mDeclaration
		| mDeclarations mDeclaration
		;

mLibraries	: mLibrary
		| mLibraries mLibrary
		;

LINE	: ASSIGNMENT ';'		{ ; }
	| LINE ASSIGNMENT ';'		{ ; }
	| PRINT EXP ';'			{ printf("%d\n", $2); }
	| LINE PRINT EXP ';'		{ printf("%d\n", $3); }
	| SCAN ';'			{ scanf(); }
	| LINE SCAN ';'			{ scanf(); }
	| IF COMPARISSON LINE		{ if($2) { $3 } }
	| IF COMPARISSON LINE ELSE LINE	{ if($2) { $3 } else { $5 } }
	;
