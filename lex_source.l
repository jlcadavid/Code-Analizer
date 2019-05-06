%option yylineno
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>		
#include <math.h>
#include "y.tab.h"	// GENERADO POR yacc -d

int _lineno = 1;
int token_index = 0;
char tokens[10000];
char errs[100000];
%}

%option noyywrap

DIGITO		[0-9]
LETRA		[a-zA-Z\242-\377]
MAIN		Main|main
ALFA		{LETRA}|{DIGITO}
ENTERO		[1-9]{DIGITO}*|0
EXPONENTE	[eE][+-]?{ENTERO}
REAL		{ENTERO}(\.{ENTERO})?{EXPONENTE}?
PALABRA		{LETRA}+
ID		[*]?{LETRA}{ALFA}*
CADENA		["']([ ]*({ALFA}|%|,|;|:|_|[-]|[+])+[ ]*)*["']
COMENTARIO	[/][/]([ ]*({ALFA}|%|,|;|:|_|[-]|[+])+[ ]*)*
COMENTARIOS	[/][*]([ ]*({ALFA}|%|,|;|:|_|[-]|[+]|[\n]|[\t]|[*]|[ ])+[ ]*)*[*][/]
ERROR		({ENTERO}|{REAL}|{CADENA}|{COMENTARIO}|{COMENTARIOS}|%|:|_)+{ID}
VERDADERO	True|true
FALSO		False|false
%%

"void"		{ fprintf(yyout, " VOID "); 			return VACIO; 		}
{VERDADERO}	{ fprintf(yyout, " true ");		 	return VERDADERO;	}
{FALSO}		{ fprintf(yyout, " false ");		 	return FALSO;		}
"if"		{ fprintf(yyout, " SI "); 			return SI; 		}
"else"		{ fprintf(yyout, " SINO "); 			return SINO; 		}
"for"		{ fprintf(yyout, " PARA "); 			return PARA; 		}
"do"		{ fprintf(yyout, " HACER ");			return HACER; 		}
"while"		{ fprintf(yyout, " MIENTRAS QUE "); 		return MIENTRAS_QUE; 	}
"switch"	{ fprintf(yyout, " DEPENDIENDO DE "); 		return DEPENDIENDO_DE; 	}
"case"		{ fprintf(yyout, " CASO "); 			return CASO; 		}
"default"	{ fprintf(yyout, " POR DEFECTO ");		return POR_DEFECTO; 	}
"break"		{ fprintf(yyout, " DETENER "); 			return INTERRUMPIR; 	}
"bool"		{ fprintf (yyout, " BOOLEANO ");	 	return BOOLEANO;	}
"int"		{ fprintf(yyout, " ENTERO "); 			return ENTERO; 		}
"float"		{ fprintf(yyout, " REAL "); 			return REAL; 		}
"char"		{ fprintf(yyout, " CARACTER "); 		return CARACTER; 	}
"printf"	{ fprintf(yyout, " ESCRIBIR "); 		return ESCRIBIR; 	}
"scanf"		{ fprintf(yyout, " LEER "); 			return LEER; 		}
"return"	{ fprintf(yyout, " RETORNA "); 			return RETORNAR; 	}
{MAIN}		{ fprintf(yyout, " MAIN "); 			return MAIN; 	}
"<--"		{ fprintf(yyout, " <-- "); 			return ASIGNAR; 	}
"+" 		{ fprintf(yyout, " + "); 			return SUMAR; 		}
"++"		{ fprintf(yyout, " ++ ");	 		return SUMAR_1; 	}
"-" 		{ fprintf(yyout, " - "); 			return RESTAR; 		}
"--"		{ fprintf(yyout, " -- "); 			return RESTAR_1; 	}
"*" 		{ fprintf(yyout, " * "); 			return MULTIPLICAR; 	}
"/" 		{ fprintf(yyout, " / "); 			return DIVIDIR; 		}
"%"		{ fprintf(yyout, " %% "); 			return MODULO; 		}
"^" 		{ fprintf(yyout, " ^ "); 			return POTENCIA; 	}
"="		{ fprintf(yyout, " = "); 			return ASIGNAR;		}
"!"		{ fprintf(yyout, " ! "); 			return NEGAR;		}
"~"		{ fprintf(yyout, " ~ ");	 		return NEGAR;		}
"<="		{ fprintf(yyout, " <= ");	 		return MENOR_IGUAL_QUE;	}
">="		{ fprintf(yyout, " >= "); 			return MAYOR_IGUAL_QUE;	}
"!="		{ fprintf(yyout, " != "); 			return DIFERENTE_DE;	}
"=="		{ fprintf(yyout, " == "); 			return IGUAL_QUE;	}
"<>"		{ fprintf(yyout, " <> "); 			return DIFERENTE_DE;	}
">"		{ fprintf(yyout, " > "); 			return MAYOR_QUE;	}
"<"		{ fprintf(yyout, " < "); 			return MENOR_QUE;	}
"&"		{ fprintf(yyout, " & "); 			return Y;		}
"&&"		{ fprintf(yyout, " && "); 			return Y;		}
"|"		{ fprintf(yyout, " | "); 			return O;		}
"||"		{ fprintf(yyout, " || "); 			return O;		}
"\("		{ fprintf(yyout, " ( "); 			return PAR_IZQ;		}
"\)"		{ fprintf(yyout, " ) "); 			return PAR_DER;		}
"{"		{ fprintf(yyout, " { "); 			return LLA_IZQ;		}
"}"		{ fprintf(yyout, " } "); 			return LLA_DER;		}
"["		{ fprintf(yyout, " [ "); 			return COR_IZQ;		}
"]"		{ fprintf(yyout, " ] "); 			return COR_DER;		}
":"		{ fprintf(yyout, " : "); 			return PP;		}
";"		{ fprintf(yyout, " ; "); 			return PyC;		}
","		{ fprintf(yyout, " , "); 			return COMA;		}
"\."		{ fprintf(yyout, " ."); 			/* NO ES UTIL */	}
"\n"		{ fprintf(yyout, "\n"); ++_lineno; 		/* NO ES UTIL */	}
"\t"		{ fprintf(yyout, "%s", yytext); ++_lineno; 	/* NO ES UTIL */	}
[ ]		;

{COMENTARIOS}	;
{COMENTARIO}	;
{CADENA}	{ fprintf(yyout, " STRING(%s) ", yytext);	return V_CADENA;}
{REAL}		{ fprintf(yyout, " FLOAT(%s) ", yytext); 	return V_REAL;	}
{ENTERO}	{ fprintf(yyout, " INT(%s) ", yytext); 		return V_ENTERO;}
{ID}		{ 
			//printf("ID: %s ", yytext);
			fprintf(yyout, " ID(%s) ", yytext);			
			char *result = malloc(strlen("ID: ") +strlen(yytext) +strlen("\t") +1);
			strcpy(result, "ID: ");
			strcat(result, yytext);
			strcat(result, "\t");
			if(!strstr(tokens, result)){
				strcat(tokens, result);			
			}
			return ID;
		}
{ERROR}		{ 
			//printf("\nERROR EN LINEA %d, EN %s\n", _lineno, yytext); 
			fprintf(yyout, " L_ERROR ");
			char str[12];
			sprintf(str, "%d", _lineno);
			char* result = malloc(strlen("\tERROR EN LINEA ") +strlen(str) +strlen(", EN ") +strlen(yytext) +strlen("\n") +1);
			strcpy(result, "\tERROR EN LINEA ");
			strcat(result, str);
			strcat(result, ", EN ");
			strcat(result, yytext);
			strcat(result, "\n");
			strcat(errs, result);		
			++_lineno; 
			return L_ERROR;
		}
<<EOF>>		{ fprintf(yyout, " EOF "); 			return E_O_F; }

.		{ 
			printf("\nERROR EN LINEA %d, EN %s\n", _lineno, yytext); 
			char str[12];
			sprintf(str, "%d", _lineno);
			char* result = malloc(strlen("\tERROR EN LINEA ") +strlen(str) +strlen(", EN ") +strlen(yytext) +strlen("\n") +1);
			strcpy(result, "\tERROR EN LINEA ");
			strcat(result, str);
			strcat(result, ", EN ");
			strcat(result, yytext);
			strcat(result, "\n");
			strcat(errs, result);		
			++_lineno; 
		}
%%
