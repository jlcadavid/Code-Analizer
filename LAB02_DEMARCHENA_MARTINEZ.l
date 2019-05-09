%option yylineno
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>		
#include <math.h>
#include "y.tab.h"	// GENERADO POR yacc -d

int _lineno = 1;
int token_index = 0;
void yyerror(const char*);
char libraries[10000];
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
ID		{LETRA}{ALFA}*
CADENA		["']([ ]*({ALFA}|!|%|,|;|:|_|[-]|[+])+[ ]*)*["']
COMENTARIO	[/][/]([ ]*({ALFA}|%|,|;|:|_|[-]|[+])+[ ]*)*
COMENTARIOS	[/][*]([ ]*({ALFA}|%|,|;|:|_|[-]|[+]|[\n]|[\t]|[*]|[ ])+[ ]*)*[*][/]
ARCHIVO		{ID}(\.{ID})+
LIBRERIA	[<"]{ARCHIVO}[>"]
ERROR		({ENTERO}|{REAL}|{CADENA}|{COMENTARIO}|{COMENTARIOS}|%|:|_)+{ID}
VERDADERO	True|true
FALSO		False|false
%%

"#include"	{ fprintf(yyout, "INCLUIR")				return INCLUDE;			}	
"void"		{ fprintf(yyout, " VOID "); 				return VACIO; 			}
{VERDADERO}	{ fprintf(yyout, " true ");		 		return VERDADERO;		}
{FALSO}		{ fprintf(yyout, " false ");		 		return FALSO;			}
"if"		{ fprintf(yyout, " SI "); 				return SI;	 		}
"else"		{ fprintf(yyout, " SINO "); 				return SINO; 			}
"for"		{ fprintf(yyout, " PARA "); 				return PARA; 			}
"do"		{ fprintf(yyout, " HACER ");				return HACER; 			}
"while"		{ fprintf(yyout, " MIENTRAS QUE "); 			return MIENTRAS_QUE; 		}
"switch"	{ fprintf(yyout, " DEPENDIENDO DE "); 			return DEPENDIENDO_DE; 		}
"case"		{ fprintf(yyout, " CASO "); 				return CASO; 			}
"default"	{ fprintf(yyout, " POR DEFECTO ");			return POR_DEFECTO; 		}
"break"		{ fprintf(yyout, " DETENER "); 				return INTERRUMPIR; 		}
"bool"		{ fprintf (yyout, " BOOLEANO ");	 		return BOOLEANO;		}
"int"		{ fprintf(yyout, " ENTERO "); 				return ENTERO; 			}
"float"		{ fprintf(yyout, " REAL "); 				return REAL; 			}
"char"		{ fprintf(yyout, " CARACTER "); 			return CARACTER; 		}
"printf"	{ fprintf(yyout, " ESCRIBIR "); 			return ESCRIBIR; 		}
"scanf"		{ fprintf(yyout, " LEER "); 				return LEER; 			}
"return"	{ fprintf(yyout, " RETORNA "); 				return RETORNAR; 		}
{MAIN}		{ fprintf(yyout, " MAIN "); 				return MAIN;	 		}
"<--"		{ fprintf(yyout, " <-- "); 				return '='; 			}
"+" 		{ fprintf(yyout, " + "); 				return '+'; 			}
"-" 		{ fprintf(yyout, " - "); 				return '-'; 			}
"*" 		{ fprintf(yyout, " * "); 				return '*'; 			}
"/" 		{ fprintf(yyout, " / "); 				return '/'; 			}
"%"		{ fprintf(yyout, " %% "); 				return '%'; 			}
"^" 		{ fprintf(yyout, " ^ "); 				return '^'; 			}
"="		{ fprintf(yyout, " = "); 				return '=';			}
"!"		{ fprintf(yyout, " ! "); 				return '!';			}
"~"		{ fprintf(yyout, " ~ ");	 			return '!';			}
">"		{ fprintf(yyout, " > "); 				return '>';			}
"<"		{ fprintf(yyout, " < "); 				return '<';			}
"&"		{ fprintf(yyout, " & "); 				return Y;			}
"&&"		{ fprintf(yyout, " && "); 				return Y;			}
"|"		{ fprintf(yyout, " | "); 				return O;			}
"||"		{ fprintf(yyout, " || "); 				return O;			}
"\("		{ fprintf(yyout, " ( "); 				return '(';			}
"\)"		{ fprintf(yyout, " ) "); 				return ')';			}
"{"		{ fprintf(yyout, " { "); 				return '{';			}
"}"		{ fprintf(yyout, " } "); 				return '}';			}
"["		{ fprintf(yyout, " [ "); 				return '[';			}
"]"		{ fprintf(yyout, " ] "); 				return ']';			}
":"		{ fprintf(yyout, " : "); 				return ':';			}
";"		{ fprintf(yyout, " ; "); 				return ';';			}
","		{ fprintf(yyout, " , "); 				return ',';			}
"\."		{ fprintf(yyout, " ."); 				/* NO ES UTIL */		}
"\n"		{ fprintf(yyout, "\n"); ++_lineno; 			/* NO ES UTIL */		}
"\t"		{ fprintf(yyout, "%s", yytext); 			/* NO ES UTIL */		}
[ ]		;	

{COMENTARIOS}	;
{COMENTARIO}	;
{CADENA}	{ fprintf(yyout, " STRING(%s) ", yytext);	return V_CADENA;}
{ENTERO}	{ fprintf(yyout, " INT(%s) ", yytext); 		return V_ENTERO;}
{REAL}		{ fprintf(yyout, " FLOAT(%s) ", yytext); 	return V_REAL;	}

{LIBRERIA}	{ 
				fprintf(yyout, " LIBRERIA(%s) ", yytext);			
				char *result = malloc(strlen("LIBRERIA: ") +strlen(yytext) +strlen("\t") +1);
				strcpy(result, "LIBRERIA: ");
				strcat(result, yytext);
				strcat(result, "\t");
				if(!strstr(libraries, result)){
					strcat(libraries, result);			
				}
				return LIBRERIA;
		}
{ID}		{ 
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
				fprintf(yyout, " L_ERROR ");
				char str[12];
				sprintf(str, "%d", _lineno);
				char* result = malloc(strlen("\tERROR LEXICO EN LINEA ") +strlen(str) +strlen(", en '") +strlen(yytext) +strlen("'\n") +1);
				strcpy(result, "\tERROR EN LINEA ");
				strcat(result, str);
				strcat(result, ", en '");
				strcat(result, yytext);
				strcat(result, "'\n");
				strcat(errs, result);		
				++_lineno; 
				return L_ERROR;
		}


.		{ 
			printf("\nERROR EN LINEA %d, EN %s\n", _lineno, yytext); 
			char str[12];
			sprintf(str, "%d", _lineno);
			char* result = malloc(strlen("\tERROR EN LINEA ") +strlen(str) +strlen(", en ") +strlen(yytext) +strlen("\n") +1);
			strcpy(result, "\tERROR EN LINEA ");
			strcat(result, str);
			strcat(result, ", EN ");
			strcat(result, yytext);
			strcat(result, "\n");
			strcat(errs, result);		
			++_lineno; 
		}
%%

void print_in_lex(){
	fprintf(yyout, "\n\nids:\n");
	fprintf(yyout, "%s", tokens);
	fprintf(yyout, "\n\nerrores:\n");
	fprintf(yyout, "%s", errs);
}
