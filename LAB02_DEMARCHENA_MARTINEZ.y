%locations
%define parse.error verbose
%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
#include <string.h>

int err_c = 0;
int err_l = 0;
int can_write = 0;
char errs[20][55];
void print();
%}

//%union {int mInt; float mDouble; char mChar[]; bool mBool;}
// INICIO DE LA GRAMATICA:
%start PROGRAM_START

// TOKENS ASOCIADOS CON NOMBRES
%token MAIN
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
%token MIENTRAS_QUE
%token DEPENDIENDO_DE
%token CASO
%token POR_DEFECTO
%token INTERRUMPIR
%token ESCRIBIR
%token LEER
%token RETORNAR
%token VERDADERO
%token FALSO

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
%token NEGAR
%token MENOR_IGUAL_QUE
%token MAYOR_IGUAL_QUE
%token DIFERENTE_DE
%token IGUAL_QUE
%token MAYOR_QUE
%token MENOR_QUE
%token Y
%token O
%token PyC
%token PP

// TOKENS PARA AGRUPADORES 
%token PAR_IZQ
%token PAR_DER
%token LLA_IZQ
%token LLA_DER
%token COR_IZQ
%token COR_DER
%token COMA

// TOKENS RELACIONADOS CON ERRORES LEXICOS
%token L_ERROR

//FIN DE LA GRAMATICA:
// %token E_O_F

%%

/* LENGUAJE PARECIDO A C */

PROGRAM_START: 
	  TIPO_FUN NOMBRE_FUN PAR_IZQ OPT_PARAMS PAR_DER LLA_IZQ OPT_ARGS LLA_DER { printf("\nMNG -> PROGRAM_START"); }
	;

NOMBRE_FUN: 
	  MAIN 		{ printf("\nMNG -> MAIN"); }
	| LEER 		{ printf("\nMNG -> MAIN"); }
	| ESCRIBIR	{ printf("\nMNG -> MAIN"); }
	;

TIPO_FUN: 
	  VACIO	{ printf("\nMNG -> TIPO_FUN"); }
	| TIPO	{ printf("\nMNG -> TIPO_FUN"); }
	;

TIPO: 
	  ENTERO 	{ printf("\nMNG -> TIPO"); }
	| REAL 		{ printf("\nMNG -> TIPO"); }
	| CARACTER 	{ printf("\nMNG -> TIPO"); }
	| BOOLEANO	{ printf("\nMNG -> TIPO"); }
	;

OPT_PARAMS: 
	  PARAM OPT_PARAM	{ printf("\nMNG -> OPT_PARAMS"); }
	| /* VACIO */		{ printf("\nMNG -> OPT_PARAMS"); }
	;

PARAM: 
	  TIPO ID_EL	{ printf("\nMNG -> PARAM"); }
	;		

ID_EL: 
	  ID 	  { printf("\nMNG -> OPT_PARAMS"); }
	| L_ERROR { printf("\nMNG -> OPT_PARAMS"); /*print("ERROR LEXICO EN LA LINEA: ", 0); err_c++; err_l++;*/ }
	; 	

OPT_PARAM: 
	  COMA PARAM OPT_PARAM { printf("\nMNG -> OPT_PARAM"); }
	| /* VACIO */ { printf("\nMNG -> OPT_PARAM"); }
	;

OPT_ARGS: 
	  ARG OPT_ARG { printf("\nMNG -> OPT_ARGS"); }
	| /* VACIO */ { printf("\nMNG -> OPT_ARGS"); }	
	;

ARG: 
	  DECLARACION_SI 				{ printf("\nMNG -> ARG"); }
	| DECLARACION_PARA 				{ printf("\nMNG -> ARG"); }
	| DECLARACION_MIENTRAS_QUE 		{ printf("\nMNG -> ARG"); }
	| DECLARACION_HACER_HASTA		{ printf("\nMNG -> ARG"); }
	| DECLARACION_DEPENDIENDO_DE	{ printf("\nMNG -> ARG"); }
	| DECLARACION_LLAMAR_FUN		{ printf("\nMNG -> ARG"); }
	| DECLARACION_ASIGNAR_A_VAR		{ printf("\nMNG -> ARG"); }
	//| error
	;

OPT_ARG: 
	    ARG OPT_ARG 	{ printf("\nMNG -> OPT_ARG"); }
	  | /* VACIO */		{ printf("\nMNG -> OPT_ARG"); }
	  ;

DECLARACION_SI: 
	  SI PAR_IZQ DECLARACION_LOGICA OPT_DECLARACION_LOGICA PAR_DER LLA_IZQ OPT_ARGS LLA_DER DECLARACION_SINO 		{ printf("\nMNG -> DECLARACION_SI"); } 
	| error PAR_IZQ 																								{ printf("\nMNG -> DECLARACION_SI"); }
	| SI error DECLARACION_LOGICA 																					{ printf("\nMNG -> DECLARACION_SI"); }
	| SI PAR_IZQ error DECLARACION_LOGICA 																			{ printf("\nMNG -> DECLARACION_SI"); }
	| SI PAR_IZQ error OPT_DECLARACION_LOGICA 																		{ printf("\nMNG -> DECLARACION_SI"); } 
	| SI PAR_IZQ DECLARACION_LOGICA  error OPT_DECLARACION_LOGICA 													{ printf("\nMNG -> DECLARACION_SI"); }
	| SI PAR_IZQ DECLARACION_LOGICA error PAR_DER 																	{ printf("\nMNG -> DECLARACION_SI"); }
	| SI PAR_IZQ DECLARACION_LOGICA OPT_DECLARACION_LOGICA error LLA_IZQ 											{ printf("\nMissing: ( -> DECLARACION_SI"); }
	| SI PAR_IZQ DECLARACION_LOGICA OPT_DECLARACION_LOGICA PAR_DER error OPT_ARGS 									{ printf("\nMNG -> DECLARACION_SI"); }
	| SI PAR_IZQ DECLARACION_LOGICA OPT_DECLARACION_LOGICA PAR_DER LLA_IZQ OPT_ARGS error LLA_DER 					{ printf("\nMNG -> DECLARACION_SI"); }
	| SI PAR_IZQ DECLARACION_LOGICA OPT_DECLARACION_LOGICA PAR_DER LLA_IZQ OPT_ARGS LLA_DER  error DECLARACION_SINO { printf("\nMNG -> DECLARACION_SI"); } 
//	| error
	;

DECLARACION_LOGICA: 
	  OPT_NEG OPT_PARS_L { printf("\nMNG -> DECLARACION_LOGICA"); }
	;

OPT_NEG: 
	  NEGAR 		{ printf("\nMNG -> OPT_NEG"); }
	| /* VACIO */	{ printf("\nMNG -> OPT_NEG"); }
	;

OPT_PARS_L: 
	  VALOR 											{ printf("\nMNG -> OPT_PARS_L"); }
	| VALOR OPERADOR_LOGICO VALOR						{ printf("\nMNG -> OPT_PARS_L"); }
	| PAR_IZQ VALOR PAR_DER								{ printf("\nMNG -> OPT_PARS_L"); }
	| PAR_IZQ VALOR OPERADOR_LOGICO VALOR PAR_DER		{ printf("\nMNG -> OPT_PARS_L"); }	
	;

VALOR: 
	  VERDADERO 				{ printf("\nMNG -> VALOR"); }
	| FALSO 					{ printf("\nMNG -> VALOR"); }
	| PARAM_FUN 				{ printf("\nMNG -> VALOR"); }
	| DECLARACION_USAR_FUN 		{ printf("\nMNG -> VALOR"); }
	;

DECLARACION_USAR_FUN: 
	  NOMBRE_FUN PAR_IZQ OPT_PARAMS_FUN PAR_DER		{ printf("\nMNG -> DECLARACION_USAR_FUN"); }
	;

OPT_PARAMS_FUN: 
	  PARAM_FUN OPT_PARAM_FUN	{ printf("\nMNG -> OPT_PARAMS_FUN"); }
	;

PARAM_FUN: 
	  VERDADERO					{ printf("\nMNG -> PARAM_FUN"); }
	| FALSO						{ printf("\nMNG -> PARAM_FUN"); }
	| V_ENTERO 					{ printf("\nMNG -> PARAM_FUN"); }
	| V_REAL					{ printf("\nMNG -> PARAM_FUN"); }
	| V_CADENA					{ printf("\nMNG -> PARAM_FUN"); }
	| ID_EL						{ printf("\nMNG -> PARAM_FUN"); }
	| DECLARACION_USAR_FUN		{ printf("\nMNG -> PARAM_FUN"); }
	;

OPT_PARAM_FUN: 
	  COMA PARAM_FUN OPT_PARAM_FUN 	{ printf("\nMNG -> OPT_PARAM_FUN"); }
	| /* VACIO*/					{ printf("\nMNG -> OPT_PARAM_FUN"); }
	;

OPERADOR_ARITMETICO: 
	  SUMAR				{ printf("\nMNG -> OPERADOR_ARITMETICO"); }
	| RESTAR			{ printf("\nMNG -> OPERADOR_ARITMETICO"); }
	| MULTIPLICAR		{ printf("\nMNG -> OPERADOR_ARITMETICO"); }
	| DIVIDIR			{ printf("\nMNG -> OPERADOR_ARITMETICO"); }
	| POTENCIA			{ printf("\nMNG -> OPERADOR_ARITMETICO"); }
	| MODULO 			{ printf("\nMNG -> OPERADOR_ARITMETICO"); }
	;

OPERADOR_LOGICO: 
	  IGUAL_QUE 		{ printf("\nMNG -> OPERADOR_LOGICO"); }
	| MAYOR_QUE 		{ printf("\nMNG -> OPERADOR_LOGICO"); }
	| MENOR_QUE 		{ printf("\nMNG -> OPERADOR_LOGICO"); }
	| DIFERENTE_DE 		{ printf("\nMNG -> OPERADOR_LOGICO"); }
	| MAYOR_IGUAL_QUE 	{ printf("\nMNG -> OPERADOR_LOGICO"); }
	| MENOR_IGUAL_QUE	{ printf("\nMNG -> OPERADOR_LOGICO"); }
	;

OPT_DECLARACION_LOGICA: 
	  Y_O DECLARACION_LOGICA OPT_DECLARACION_LOGICA		{ printf("\nMNG -> OPT_DECLARACION_LOGICA"); } 
	| /* VACIO */										{ printf("\nMNG -> OPT_DECLARACION_LOGICA"); }
	;

Y_O: 
	  Y 	{ printf("\nMNG -> Y_O"); }
	| O		{ printf("\nMNG -> Y_O"); }
	;

DECLARACION_SINO: 
	  SINO SINO_P	{ printf("\nMNG -> DECLARACION_SINO"); }
	| /* VACIO */	{ printf("\nMNG -> DECLARACION_SINO"); }
	;

SINO_P: 
	  DECLARACION_SI 			{ printf("\nMNG -> SINO_P"); }
	| LLA_IZQ OPT_ARGS LLA_DER	{ printf("\nMNG -> SINO_P"); }
	;

DECLARACION_PARA: 
	  PARA PAR_IZQ OPT_TIPO ID_EL ASIGNAR_EL RoN PyC ID_EL OPERADOR_LOGICO PARAM_FUN PyC PASO PAR_DER LLA_IZQ OPT_ARGS LLA_DER	{ printf("\nMNG -> DECLARACION_PARA"); }
	;

OPT_TIPO:
	  ENTERO 		{ printf("\nMNG -> OPT_TIPO"); }
	| REAL			{ printf("\nMNG -> OPT_TIPO"); }
	| /* VACIO */	{ printf("\nMNG -> OPT_TIPO"); }
	;

RoN: 
	  V_ENTERO 	{ printf("\nMNG -> RoN"); }
	| V_REAL	{ printf("\nMNG -> RoN"); }
	;

PASO: 
	  PASO_1 ID_EL 	{ printf("\nMNG -> PASO"); }
	| ID_EL PASO_F	{ printf("\nMNG -> PASO"); }
	;

PASO_F: 
	  PASO_1 { printf("\nMNG -> PASO_F"); }
	| PASO_2 { printf("\nMNG -> PASO_F"); }
	;

PASO_2: 
	  ASIGNAR_EL ID_EL PASO_3	{ printf("\nMNG -> PASO_2"); }
	;

PASO_3: 
	  PASO_1 						{ printf("\nMNG -> PASO_3"); }
	| OPERADOR_ARITMETICO ID_EL		{ printf("\nMNG -> PASO_3"); }
	;

PASO_1: 
	  SUMAR_1 	{ printf("\nMNG -> PASO_1"); }
	| RESTAR_1	{ printf("\nMNG -> PASO_1"); }
	;


DECLARACION_MIENTRAS_QUE:
	  MIENTRAS_QUE PAR_IZQ DECLARACION_LOGICA OPT_DECLARACION_LOGICA PAR_DER LLA_IZQ OPT_ARGS LLA_DER { printf("\nMNG -> DECLARACION_MIENTRAS_QUE"); }
	;						

DECLARACION_HACER_HASTA:
	  HACER LLA_IZQ OPT_ARGS LLA_DER MIENTRAS_QUE PAR_IZQ DECLARACION_LOGICA OPT_DECLARACION_LOGICA PAR_DER { printf("\nMNG -> DECLARACION_HACER_HASTA"); }
	;

DECLARACION_DEPENDIENDO_DE:
	  DEPENDIENDO_DE PAR_IZQ ID_EL PAR_DER LLA_IZQ OPT_CASOS LLA_DER { printf("\nMNG -> DECLARACION_DEPENDIENDO_DE"); }
	;

OPT_CASOS:
	  DECLARACION_CASO OPT_CASO { printf("\nMNG -> OPT_CASOS"); }
	;

DECLARACION_CASO: 
	  CASO CASO_P PP OPT_ARGS P_BREAK	{ printf("\nMNG -> DECLARACION_CASO"); }
	;

CASO_P: 
	  V_ENTERO 	{ printf("\nMNG -> CASO_P"); }
	| V_REAL	{ printf("\nMNG -> CASO_P"); }
	;

P_BREAK: 
	  INTERRUMPIR PyC 	{ printf("\nMNG -> P_BREAK"); }
	| /**/ 				{ printf("\nMNG -> P_BREAK"); }
	;

OPT_CASO: 
	  DECLARACION_CASO OPT_CASO { printf("\nMNG -> OPT_CASO"); }
	| /**/						{ printf("\nMNG -> OPT_CASO"); }
	;

DECLARACION_LLAMAR_FUN: 
	  DECLARACION_USAR_FUN PyC	{ printf("\nMNG -> DECLARACION_LLAMAR_FUN"); }
	;

DECLARACION_ASIGNAR_A_VAR: 
	  ID_EL ASIGNAR_EL VAR_1 PyC	{ printf("\nMNG -> DECLARACION_ASGINAR_A_VAR"); }
	;

VAR_1: 
	  DECLARACION_USAR_VAR 	{ printf("\nMNG -> VAR_1"); }
	| PARAM_FUN 			{ printf("\nMNG -> VAR_1"); }
	;

DECLARACION_USAR_VAR: 
	  PARAM_FUN VAR_2	{ printf("\nMNG -> DECLARACION_USAR_VAR"); }
	;

VAR_2: 
	  OP_L_O PARAM_FUN 			{ printf("\nMNG -> VAR_2"); }
	| OP_L_A PARAM_FUN MAS_MAT	{ printf("\nMNG -> VAR_2"); }
	;

OP_L_O: 
	  OPERADOR_LOGICO	{ printf("\nMNG -> OP_L_O"); }
	| Y_O				{ printf("\nMNG -> OP_L_O"); }
	| NEGAR				{ printf("\nMNG -> OP_L_O"); }
	;

OP_L_A: 
	  OPERADOR_ARITMETICO	{ printf("\nMNG -> OP_L_A"); }
 	;

MAS_MAT: 
	  OP_L_A PARAM_FUN MAS_MAT 	{ printf("\nMNG -> MAS_MAT"); }
	| /**/ 						{ printf("\nMNG -> MAS_MAT"); }
	;

ASIGNAR_EL: 
	  ASIGNAR { printf("\nMNG -> ASGINAR_EL"); }
	| L_ERROR { print("ERROR LEXICO EN LA LINEA: ", 0); err_c++; err_l++; }
	;

%% 

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;

void yyerror(char *s) {
	print("ERROR SINTACTICO EN LA LINEA: ", 2); 
	err_c++; 
	err_l++;
}

void print(char *t, int o){
	if(o == 0){
		printf( "%s%d\n", t, (yylineno));
		//snprintf(errs[err_c], "%s%d\n", t, (yylineno));
	}
	if(o == 1){
		printf("%s\n", t);
		//snprintf(errs[err_c], "%s\n", t);
	}
	if(o == 2){
		printf( "%s%d\n", t, (yylineno -1));
		//snprintf(errs[err_c], "%s%d\n", t, (yylineno));
	}
}

int main(int argc, char *argv[]) {
	printf("\nInput: %s\n", argv[1]);
	FILE *fp = fopen(argv[1], "r");
	FILE *lex_out_file = fopen("salida_lex.txt", "w"); // write only 
	if (!fp) {
		fprintf(lex_out_file,"\nNo se encuentra el archivo...\n");
		return(-1);
	}
	yyin = fp;
	yyout = lex_out_file;
	//printf("ANTES\n");
	yyparse();
	//printf("DESPUES\n");
	fclose(lex_out_file);
	fclose(fp);
	/*	
	if(can_write == 1){
		FILE *yacc_out_file = fopen("salida_yacc.txt", "w"); // write only
		if(!yacc_out_file){
			printf("\nKELLY...\n");
			exit(EXIT_FAILURE);	
		}		
		for(int i = 0; i < err_c; i++){
			fprintf(yacc_out_file, "%s", errs[i]);
		}
		fclose(yacc_out_file);	
	}*/	
	return(0);
}

