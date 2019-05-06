%locations
%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>

int err_c = 0;
int err_l = 0;
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
%token E_O_F

%%

/* LENGUAJE PARECIDO A C */

PROGRAM_START: TIPO_FUN NOMBRE_FUN PAR_IZQ OPT_PARAMS PAR_DER LLA_IZQ OPT_ARGS LLA_DER STOP;

STOP: E_O_F { 
				if(err_c == 0){
					print("NO SE HAN PRESENTADO ERRORES!", 1);		
				}
				exit(1); 
			}
	;

NOMBRE_FUN: MAIN | LEER | ESCRIBIR;

TIPO_FUN: VACIO| TIPO;

TIPO: ENTERO | REAL | CARACTER | BOOLEANO;

OPT_PARAMS	: PARAM OPT_PARAM
			| /* VACIO */
			;

PARAM: TIPO ID_EL;		

ID_EL: ID | L_ERROR { print("ERROR LEXICO EN LA LINEA: ", 0); err_c++; err_l++; }; 	

OPT_PARAM	: COMA PARAM OPT_PARAM 
			| /* VACIO */
			;

OPT_ARGS: ARG OPT_ARG
		| /* VACIO */
		;

ARG : DECLARACION_SI 
	| DECLARACION_PARA 
	| DECLARACION_MIENTRAS_QUE 
	| DECLARACION_HACER_HASTA
	| DECLARACION_DEPENDIENDO_DE
	| DECLARACION_LLAMAR_FUN
	| DECLARACION_ASIGNAR_A_VAR
	;

OPT_ARG : ARG OPT_ARG | /* VACIO */;

DECLARACION_SI: SI PAR_IZQ DECLARACION_LOGICA OPT_DECLARACION_LOGICA PAR_DER LLA_IZQ OPT_ARGS LLA_DER DECLARACION_SINO;

DECLARACION_LOGICA: OPT_NEG OPT_PARS_L;

OPT_NEG	: NEGAR | /* VACIO */;

OPT_PARS_L  : VALOR 
			| VALOR OPERADOR_LOGICO VALOR					
			| PAR_IZQ VALOR PAR_DER
			| PAR_IZQ VALOR OPERADOR_LOGICO VALOR PAR_DER	
			;

VALOR	: VERDADERO 
		| FALSO 
		| PARAM_FUN 
		| DECLARACION_USAR_FUN 
		;

DECLARACION_USAR_FUN: NOMBRE_FUN PAR_IZQ OPT_PARAMS_FUN PAR_DER;

OPT_PARAMS_FUN: PARAM_FUN OPT_PARAM_FUN;

PARAM_FUN	: VERDADERO
			| FALSO
			| V_ENTERO 
			| V_REAL
			| V_CADENA
			| ID_EL		
			| DECLARACION_USAR_FUN
			;

OPT_PARAM_FUN: COMA PARAM_FUN OPT_PARAM_FUN | /* VACIO*/;

OPERADOR_ARITMETICO : SUMAR
					| RESTAR
					| MULTIPLICAR
					| DIVIDIR
					| POTENCIA
					| MODULO 
					;

OPERADOR_LOGICO : IGUAL_QUE 
				| MAYOR_QUE 	
				| MENOR_QUE 
				| DIFERENTE_DE 
				| MAYOR_IGUAL_QUE 
				| MENOR_IGUAL_QUE
				;

OPT_DECLARACION_LOGICA	: Y_O DECLARACION_LOGICA OPT_DECLARACION_LOGICA 
						| /* VACIO */
						;

Y_O : Y | O;

DECLARACION_SINO: SINO SINO_P
				| /* VACIO */
				;

SINO_P  : DECLARACION_SI 
		| LLA_IZQ OPT_ARGS LLA_DER
		;

DECLARACION_PARA: PARA PAR_IZQ ID_EL ASIGNAR_EL RoN PyC ID_EL OPERADOR_LOGICO PARAM_FUN PyC PASO PAR_DER LLA_IZQ OPT_ARGS LLA_DER;

RoN : V_ENTERO| V_REAL;

PASO: PASO_1 ID_EL | ID_EL PASO_F;

PASO_F: PASO_1 | PASO_2;

PASO_2: ASIGNAR_EL ID_EL PASO_3;

PASO_3: PASO_1 | OPERADOR_ARITMETICO ID_EL;

PASO_1  : SUMAR_1 | RESTAR_1;


DECLARACION_MIENTRAS_QUE: MIENTRAS_QUE PAR_IZQ DECLARACION_LOGICA OPT_DECLARACION_LOGICA PAR_DER LLA_IZQ OPT_ARGS LLA_DER;

DECLARACION_HACER_HASTA: HACER LLA_IZQ OPT_ARGS LLA_DER MIENTRAS_QUE PAR_IZQ DECLARACION_LOGICA OPT_DECLARACION_LOGICA PAR_DER;

DECLARACION_DEPENDIENDO_DE: DEPENDIENDO_DE PAR_IZQ ID_EL PAR_DER LLA_IZQ OPT_CASOS LLA_DER;

OPT_CASOS: DECLARACION_CASO OPT_CASO;

DECLARACION_CASO: CASO CASO_P PP OPT_ARGS P_BREAK;

CASO_P: V_ENTERO | V_REAL

P_BREAK: INTERRUMPIR PyC | /**/ ;

OPT_CASO: DECLARACION_CASO OPT_CASO | /**/;

DECLARACION_LLAMAR_FUN: DECLARACION_USAR_FUN PyC;

DECLARACION_ASIGNAR_A_VAR: ID_EL ASIGNAR_EL VAR_1 PyC;

VAR_1: DECLARACION_USAR_VAR | PARAM_FUN ;

DECLARACION_USAR_VAR: PARAM_FUN VAR_2;

VAR_2: OP_L_O PARAM_FUN | OP_L_A PARAM_FUN MAS_MAT;

OP_L_O: OPERADOR_LOGICO
		| Y_O
		| NEGAR
		;

OP_L_A: OPERADOR_ARITMETICO;

MAS_MAT: OP_L_A PARAM_FUN MAS_MAT | /**/ ;

ASIGNAR_EL: ASIGNAR | L_ERROR { print("ERROR LEXICO EN LA LINEA: ", 0); err_c++; err_l++; };


%% 

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;

void yyerror(char *s) {
	fprintf(stdout, "Error in line %d: %s\n", (yylineno), s);
}

void print(char *t, int o){
	if(o == 0){
		fprintf(stdout, "%s%d\n", t, (yylineno));
	}
	if(o == 1){
		fprintf(stdout, "%s\n", t);
	}
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

