%{
void yyerror (char *s)
#include <stdio.h>
#include <stdlib.h>
int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);
%}

%union {int mInt; float mDouble; char mChar[]; bool mBool;}
