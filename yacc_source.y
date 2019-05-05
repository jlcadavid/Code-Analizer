%locations
%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
%}

//%union {int mInt; float mDouble; char mChar[]; bool mBool;}
// INICIO DE LA GRAMATICA:
%start PROGRAM_START

// TOKENS ASOCIADOS CON NOMBRES
%token NOM_FUN
%token ID
%token V_CADENA
%token V_ENTERO
%token V_REAL
//%token mLibrary

// TOKENS PARA TIPOS
%token VACIO
%token ENTERO
%token REAL
%token CARACTER
%token BOOLEANO

// TOKENS FOR PALABRAS CLAVE
%token SI
%token SINO
%token PARA
%token HACER
%token MIENTRAS
%token DEPENDIENDO_DE
%token CASO
%token POR_DEFECTO
%token INTERRUMPIR
%token ESCRIBIR
%token LEER
%token RETORNAR

// TOKENS PARA OPERADORES
%token ASIGNAR
%token SUMAR
%token SUMAR_1
%token RESTAR
%token RESTAR_1
%token MULTIPLICAR
%token DIVIDIR
%token MODULO
%token POTENCIA
%token ASIGNAR
%token NEGAR
%token MENOR_IGUAL_QUE
%token MAYOR_IGUAL_QUE
%token DIFERENTE_DE
%token IGUAL_QUE
%token MAYOR_QUE
%token MENOR_QUE
%token Y
%token O
%token FIN_DCL

// TOKENS PARA AGRUPADORES 
%token PAR_IZQ
%token PAR_DER
%token LLAV_IZQ
%token LLAV_DER
%token COR_IZQ
%token COR_DER
%token COMA

// TOKENS RELACIONADOS CON ERRORES LEXICOS
%token L_ERROR

%%

/* DESCRIPTIONS OF EXPECTED INPUTS		CORRESPONDING ACTIONS (IN C) */

PROGRAM_START: TIPO_F;
%% 

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;

void yyerror(char *s) {
	fprintf(stdout, "Error in line %d: %s\n", (yylineno), s);
}

int main(int argc, char *argv[]) {
	printf("Input: %s\n", argv[1]);
	FILE *fp = fopen(argv[1], "r");
	FILE *lex_out_file = fopen("salida_lex.txt", "w"); // write only
	//FILE *yacc_out_file = open("salida_yacc.txt", "w"); // write only 
	if (!fp) {
		fprintf(lex_out_file,"\nNo se encuentra el archivo...\n");
		//fprintf(yacc_out_file,"\nNo se encuentra el archivo...\n");
		return(-1);
	}
	yyin = fp;
	yyout = lex_out_file;
	yyparse();
	fclose(lex_out_file);
	fclose(fp);
	//fclose(yacc_out_file);
	return(0);
}

