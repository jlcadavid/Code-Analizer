%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>		
#include <math.h>

int _lineno = 1;
int token_index = 0;
char tokens[10000];
char errs[100000];
%}

DIGITO		[0-9]
LETRA		[a-zA-Z\242-\377]
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

"Main"|"main"	{ printf("MAIN "); }
"void"		{ printf("VOID "); }
"if"		{ printf("SI "); }
"else"		{ printf("SINO "); }
"for"		{ printf("PARA "); }
"do"		{ printf("HACER "); }
"while"		{ printf("MIENTRAS QUE "); }
"switch"	{ printf("DEPENDIENDO DE "); }
"case"		{ printf("CASO "); }
"default"	{ printf("POR DEFECTO "); }
"break"		{ printf("DETENER "); }
"int"		{ printf("ENTERO "); }
"float"		{ printf("REAL "); }
"char"		{ printf("CARACTER "); }
"printf"	{ printf("ESCRIBIR "); }
"scanf"		{ printf("LEER "); }
"return"	{ printf("RETORNA "); }

"<--"		{ printf("op-asign= <-- "); }
"+" 		{ printf("op-sum= + "); }
"++"		{ printf("op-sumcont= ++ "); }
"-" 		{ printf("op-sust= - "); }
"--"		{ printf("op-sustcont= -- "); }
"*" 		{ printf("op-mult= * "); }
"/" 		{ printf("op-div= / "); }
"%"		{ char a[5]; strcpy(a, "%"); printf(" op-mod= %s ", a); }
"^" 		{ printf("op-exp= ^ "); }
"="		{ printf("op-igual= = "); }
"!"		{ printf("op-neg= ! "); }
"<="		{ printf("op-men-ig= <= "); }
">="		{ printf("op-may-ig= >= "); }
"!="		{ printf("op-difer= != "); }
"=="		{ printf("op-comp= == "); }
"<>"		{ printf("op-difer= <> "); }
">"		{ printf("op-mayor= > "); }
"<"		{ printf("op-menor= < "); }
"&"		{ printf("op-y= & "); }
"&&"		{ printf("op-comp-y= && "); }
"|"		{ printf("op-o= | "); }
"||"		{ printf("op-comp-o= || "); }

"\("		{ printf("parent-a= ( "); }
"\)"		{ printf("parent-c= ) "); }
"{"		{ printf("inicio= { "); }
"}"		{ printf("fin= } "); }
"["		{ printf("corch-a= [ "); }
"]"		{ printf("corch-c= ] "); }
":"		{ printf("doble-punto= : "); }
";"		{ printf("punto-coma= ; "); }
","		{ printf("coma= , "); }
"\."		{ printf("punto= ."); }

"\n"		{ printf("\n"); ++_lineno; }
"\t"		{ printf("\t"); ++_lineno; }
[ ]		;

{COMENTARIOS}	{ printf("cte-comentarios= %s ", yytext); }
{COMENTARIO}	{ printf("cte-comentario= %s ", yytext); }
{CADENA}	{ printf("cte-cadena= %s ", yytext); }
{BOOLEANO}	{ printf ("cte-booleano= %s ", yytext); }
{ENTERO}	{ printf("cte-entero= %s ", yytext); }
{REAL}		{ printf("cte-real= %s ", yytext); }
{ID}		{ 
			printf("ID: %s ", yytext);			
			char *result = malloc(strlen("ID: ") +strlen(yytext) +strlen("\t") +1);
			strcpy(result, "ID: ");
			strcat(result, yytext);
			strcat(result, "\t");
			if(!strstr(tokens, result)){
				strcat(tokens, result);			
			}
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

int main(int argc, char *argv[]){
/*	if(tokens != NULL){
		printf("Memory allocated!\n\n");
	}
*/
	++argv, --argc;
	if(argc > 0){
		yyin = fopen(argv[0], "r");
	}else{
		yyin = stdin;	
	}
	yylex();
	printf("\n\nIDENTIFICADORES\n%s", tokens);
	printf("\n\nERRORES:\n%s", errs);
	return 0;
}
