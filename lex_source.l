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

DIGITO		[0-9]
LETRA		[a-zA-Z\242-\377]
NOMBRE_F	({LETRA}|_)+
ALFA		{LETRA}|{DIGITO}
ENTERO		{DIGITO}+
EXPONENTE	[eE][+-]?{ENTERO}
REAL		{ENTERO}.{ENTERO}{EXPONENTE}?
PALABRA		{LETRA}+

ID		[*]?{LETRA}{ALFA}*
CADENA		["']([ ]*({ALFA}|%|,|;|:|_|[-]|[+])+[ ]*)*["']
COMENTARIO	[/][/]([ ]*({ALFA}|%|,|;|:|_|[-]|[+])+[ ]*)*
COMENTARIOS	[/][*]([ ]*({ALFA}|%|,|;|:|_|[-]|[+]|[\n]|[\t]|[*]|[ ])+[ ]*)*[*][/]
BOOLEANO	true|false
ERROR		({ENTERO}|{REAL}|{CADENA}|{COMENTARIO}|{COMENTARIOS}|%|:|_|[--]|[++])+{ID}
%%

"void"		{ fprintf(yyout, " VOID "); 		return VACIO; 		}
"if"		{ fprintf(yyout, " SI "); 		return SI; 		}
"else"		{ fprintf(yyout, " SINO "); 		return SINO; 		}
"for"		{ fprintf(yyout, " PARA "); 		return PARA; 		}
"do"		{ fprintf(yyout, " HACER ");		return HACER; 		}
"while"		{ fprintf(yyout, " MIENTRAS QUE "); 	return MIENTRAS; 	}
"switch"	{ fprintf(yyout, " DEPENDIENDO DE "); 	return DEPENDIENDO_DE; 	}
"case"		{ fprintf(yyout, " CASO "); 		return CASO; 		}
"default"	{ fprintf(yyout, " POR DEFECTO ");	return POR_DEFECTO; 	}
"break"		{ fprintf(yyout, " DETENER "); 		return INTERRUMPIR; 	}
"int"		{ fprintf(yyout, " ENTERO "); 		return ENTERO; 		}
"float"		{ fprintf(yyout, " REAL "); 		return REAL; 		}
"char"		{ fprintf(yyout, " CARACTER "); 	return CARACTER; 	}
"printf"	{ fprintf(yyout, " ESCRIBIR "); 	return ESCRIBIR; 	}
"scanf"		{ fprintf(yyout, " LEER "); 		return LEER; 		}
"return"	{ fprintf(yyout, " RETORNA "); 		return RETORNAR; 	}
{NOMBRE_F}	{ fprintf(yyout, " NOM_FUN "); 		return NOM_FUN; 	}
"<--"		{ fprintf(yyout, "op-asign= <-- "); 	return ASIGNAR; 	}
"+" 		{ fprintf(yyout, "op-sum= + "); 	return SUMAR; 		}
"++"		{ fprintf(yyout, "op-sumcont= ++ "); 	return SUMAR_1; 	}
"-" 		{ fprintf(yyout, "op-sust= - "); 	return RESTAR; 		}
"--"		{ fprintf(yyout, "op-sustcont= -- "); 	return RESTAR_1; 	}
"*" 		{ fprintf(yyout, "op-mult= * "); 	return MULTIPLICAR; 	}
"/" 		{ fprintf(yyout, "op-div= / "); 	return DIVIDIR 		}
"%"		{ fprintf(yyout, "op-mod= %% "); 	return MODULO; 		}
"^" 		{ fprintf(yyout, "op-exp= ^ "); 	return POTENCIA; 	}
"="		{ fprintf(yyout, "op-igual= = "); 	return ASIGNAR;		}
"!"		{ fprintf(yyout, "op-neg= ! "); 	return NEGAR;		}
"<="		{ fprintf(yyout, "op-men-ig= <= "); 	return MENOR_IGUAL_QUE;	}
">="		{ fprintf(yyout, "op-may-ig= >= "); 	return MAYOR_IGUAL_QUE;	}
"!="		{ fprintf(yyout, "op-difer= != "); 	return DIFERENTE_DE;	}
"=="		{ fprintf(yyout, "op-comp= == "); 	return IGUAL_QUE;	}
"<>"		{ fprintf(yyout, "op-difer= <> "); 	return DIFERENTE_DE;	}
">"		{ fprintf(yyout, "op-mayor= > "); 	return MAYOR_QUE;	}
"<"		{ fprintf(yyout, "op-menor= < "); 	return MENOR_QUE;	}
"&"		{ fprintf(yyout, "op-y= & "); 		return Y;		}
"&&"		{ fprintf(yyout, "op-comp-y= && "); 	return Y;		}
"|"		{ fprintf(yyout, "op-o= | "); 		return O;		}
"||"		{ fprintf(yyout, "op-comp-o= || "); 	return O;		}
"\("		{ fprintf(yyout, "parent-a= ( "); 	return PAR_IZQ;		}
"\)"		{ fprintf(yyout, "parent-c= ) "); 	return PAR_DER;		}
"{"		{ fprintf(yyout, "inicio= { "); 	return LLA_IZQ;		}
"}"		{ fprintf(yyout, "fin= } "); 		return LLA_DER;		}
"["		{ fprintf(yyout, "corch-a= [ "); 	return COR_IZQ;		}
"]"		{ fprintf(yyout, "corch-c= ] "); 	return COR_DER;		}
":"		{ fprintf(yyout, "doble-punto= : "); 	return ASIGNAR;		}
";"		{ fprintf(yyout, "punto-coma= ; "); 	return FIN_DCL;		}
","		{ fprintf(yyout, "coma= , "); 		return COMA;		}
"\."		{ fprintf(yyout, "punto= ."); 		/* NO ES UTIL */	}
"\n"		{ fprintf(yyout, "\n"); ++_lineno; 	/* NO ES UTIL */	}
"\t"		{ fprintf(yyout, "\t"); ++_lineno; 	/* NO ES UTIL */	}
[ ]		;

{COMENTARIOS}	{ fprintf(yyout, "cte-comentarios= %s ", yytext); }
{COMENTARIO}	{ fprintf(yyout, "cte-comentario= %s ", yytext); }
{CADENA}	{ fprintf(yyout, "cte-cadena= %s ", yytext);	return V_CADENA;}
{BOOLEANO}	{ printf ("cte-booleano= %s ", yytext); 	return BOOLEANO;}
{ENTERO}	{ fprintf(yyout, "cte-entero= %s ", yytext); 	return V_ENTERO;}
{REAL}		{ fprintf(yyout, "cte-real= %s ", yytext); 	return V_REAL;	}
{ID}		{ 
			printf("ID: %s ", yytext);			
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
			return L_ERROR;
		}

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
