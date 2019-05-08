%locations
%define parse.error verbose
%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

int err_c = 0;
int err_l = 0;
int can_write = 0;
char errs[20][55];
void print();
extern int yylineno;
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
%token '='
%token '+'
%token SUMAR_1
%token '-'
%token RESTAR_1
%token '*'
%token '/'
%token '%'
%token '^'
%token '!'
%token MENOR_IGUAL_QUE
%token MAYOR_IGUAL_QUE
%token DIFERENTE_DE
%token IGUAL_QUE
%token MAYOR_QUE
%token MENOR_QUE
%token Y
%token O
%token ';'
%token ':'

// TOKENS PARA AGRUPADORES 
%token '('
%token ')'
%token '{'
%token '}'
%token '['
%token ']'
%token ','

// TOKENS RELACIONADOS CON ERRORES LEXICOS
%token L_ERROR

//FIN DE LA GRAMATICA:
// %token E_O_F

%%

/* LENGUAJE PARECIDO A C */

PROGRAM_START: 
	  TIPO_FUN NOMBRE_FUN '(' OPT_PARAMS ')' '{' OPT_ARGS '}' { /*printf("\nMNG -> PROGRAM_START")*/ }
	;

NOMBRE_FUN: 
	  MAIN 		{ /*printf("\nMNG -> MAIN")*/ }
	| LEER 		{ /*printf("\nMNG -> MAIN")*/ }
	| ESCRIBIR	{ /*printf("\nMNG -> MAIN")*/ }
	;

TIPO_FUN: 
	  VACIO	{ /*printf("\nMNG -> TIPO_FUN")*/ }
	| TIPO	{ /*printf("\nMNG -> TIPO_FUN")*/ }
	;

TIPO: 
	  ENTERO 	{ /*printf("\nMNG -> TIPO")*/ }
	| REAL 		{ /*printf("\nMNG -> TIPO")*/ }
	| CARACTER 	{ /*printf("\nMNG -> TIPO")*/ }
	| BOOLEANO	{ /*printf("\nMNG -> TIPO")*/ }
	;

OPT_PARAMS: 
	  PARAM OPT_PARAM	{ /*printf("\nMNG -> OPT_PARAMS")*/ }
	| /* VACIO */		{ /*printf("\nMNG -> OPT_PARAMS")*/ }
	;

PARAM: 
	  TIPO ID_EL	{ /*printf("\nMNG -> PARAM")*/ }
	;		

ID_EL: 
	  ID 	  { /*printf("\nMNG -> OPT_PARAMS")*/ }
	| L_ERROR { /*printf("\nMNG -> OPT_PARAMS"); /*print("ERROR LEXICO EN LA LINEA: ", 0); err_c++; err_l++*/ }
	; 	

OPT_PARAM: 
	  ',' PARAM OPT_PARAM { /*printf("\nMNG -> OPT_PARAM")*/ }
	| /* VACIO */ { /*printf("\nMNG -> OPT_PARAM")*/ }
	;

OPT_ARGS: 
	  ARG OPT_ARG 		{ /*printf("\nMNG -> OPT_ARGS")*/ }
	| /* VACIO */ 		{ /*printf("\nMNG -> OPT_ARGS")*/ }	
	;

ARG: 
	  DECLARACION_SI 				{ /*printf("\nMNG -> ARG")*/ }
	| DECLARACION_PARA 				{ /*printf("\nMNG -> ARG")*/ }
	| DECLARACION_MIENTRAS_QUE 		{ /*printf("\nMNG -> ARG")*/ }
	| DECLARACION_HACER_HASTA		{ /*printf("\nMNG -> ARG")*/ }
	| DECLARACION_DEPENDIENDO_DE	{ /*printf("\nMNG -> ARG")*/ }
	| DECLARACION_LLAMAR_FUN		{ /*printf("\nMNG -> ARG")*/ }
	| DECLARACION_ASIGNAR_A_VAR		{ /*printf("\nMNG -> ARG")*/ }
	| error							{  yyclearin;  } 
	;

OPT_ARG: 
	    ARG OPT_ARG 	{ /*printf("\nMNG -> OPT_ARG")*/ }
	  | /* VACIO */		{ /*printf("\nMNG -> OPT_ARG")*/ }
      ;

DECLARACION_SI: 
	  SI '(' DECLARACION_LOGICA OPT_DECLARACION_LOGICA ')' '{' OPT_ARGS '}' DECLARACION_SINO 		 
	//| error SI  																									{ /*save("no se esperaba nada antes de la palabra clave 'if'")*/ }
	//| error '(' 																								{ /*save("se esperaba la palabra clave 'if'")*/ }	
	//| SI error '(' 																								{ /*save("no se esperaba nada entre un 'if' y un '('")*/ }
	//| SI error DECLARACION_LOGICA 																					{ /*save("se esperaba un '('")*/ }
	//| SI '(' error DECLARACION_LOGICA 																			{ /*save("no se esperaba nada entre un '(' y una expresion logica")*/ }
	//| SI '(' error OPT_DECLARACION_LOGICA 																		{ /*save("se esperaba una expresion logica")*/ } 
	//| SI '(' DECLARACION_LOGICA  error OPT_DECLARACION_LOGICA 													{ /*save("no se esperaba nada entre una expresion logica y una expresion logica")*/ }
	//| SI '(' DECLARACION_LOGICA error ')' 																	{ /*save("se esperaba una expresion logica")*/ }
	//| SI '(' DECLARACION_LOGICA OPT_DECLARACION_LOGICA error ')' 											{ /*save("no se esperaba nada entre una expresion logica y un ')'")*/ }
	//| SI '(' DECLARACION_LOGICA OPT_DECLARACION_LOGICA error '{' 											{ /*save("se esperaba un ')'")*/ }
	//| SI '(' DECLARACION_LOGICA OPT_DECLARACION_LOGICA ')' error '{'  									{ /*save("no se esperaba nada entre un ')' y un '{'")*/ }
	//| SI '(' DECLARACION_LOGICA OPT_DECLARACION_LOGICA ')' error OPT_ARGS 				 					{ /*save("se esperaba un '{'")*/ } 
	//| SI '(' DECLARACION_LOGICA OPT_DECLARACION_LOGICA ')' '{' error OPT_ARGS 				 			{ /*save("no se esperaba nada entre un '{' y los argumentos")*/ } 
	//| SI '(' DECLARACION_LOGICA OPT_DECLARACION_LOGICA ')' '{' error '}'   				 			{ /*save("se esperaban argumentos")*/ }
	//| SI '(' DECLARACION_LOGICA OPT_DECLARACION_LOGICA ')' '{' OPT_ARGS error '}'   				{ /*save("no se esperaba nada entre los argumentos y un '}'")*/ } 
	;

DECLARACION_LOGICA: 
	  OPT_NEG OPT_PARS_L { /*printf("\nMNG -> DECLARACION_LOGICA")*/ }
	;

OPT_NEG: 
	  '!' 		{ /*printf("\nMNG -> OPT_NEG")*/ }
	| /* VACIO */	{ /*printf("\nMNG -> OPT_NEG")*/ }
	;

OPT_PARS_L: 
	  VALOR 											{ /*printf("\nMNG -> OPT_PARS_L")*/ }
	| VALOR OPERADOR_LOGICO VALOR						{ /*printf("\nMNG -> OPT_PARS_L")*/ }
	| '(' VALOR ')'								{ /*printf("\nMNG -> OPT_PARS_L")*/ }
	| '(' VALOR OPERADOR_LOGICO VALOR ')'		{ /*printf("\nMNG -> OPT_PARS_L")*/ }	
	;

VALOR: 
	  VERDADERO 				{ /*printf("\nMNG -> VALOR")*/ }
	| FALSO 					{ /*printf("\nMNG -> VALOR")*/ }
	| PARAM_FUN 				{ /*printf("\nMNG -> VALOR")*/ }
	| DECLARACION_USAR_FUN 		{ /*printf("\nMNG -> VALOR")*/ }
	;

DECLARACION_USAR_FUN: 
	  NOMBRE_FUN '(' OPT_PARAMS_FUN ')'		{ /*printf("\nMNG -> DECLARACION_USAR_FUN")*/ }
	;

OPT_PARAMS_FUN: 
	  PARAM_FUN OPT_PARAM_FUN	{ /*printf("\nMNG -> OPT_PARAMS_FUN")*/ }
	;

PARAM_FUN: 
	  VERDADERO					{ /*printf("\nMNG -> PARAM_FUN")*/ }
	| FALSO						{ /*printf("\nMNG -> PARAM_FUN")*/ }
	| V_ENTERO 					{ /*printf("\nMNG -> PARAM_FUN")*/ }
	| V_REAL					{ /*printf("\nMNG -> PARAM_FUN")*/ }
	| V_CADENA					{ /*printf("\nMNG -> PARAM_FUN")*/ }
	| ID_EL						{ /*printf("\nMNG -> PARAM_FUN")*/ }
	| DECLARACION_USAR_FUN		{ /*printf("\nMNG -> PARAM_FUN")*/ }
	;

OPT_PARAM_FUN: 
	  ',' PARAM_FUN OPT_PARAM_FUN 	{ /*printf("\nMNG -> OPT_PARAM_FUN")*/ }
	| /* VACIO*/					{ /*printf("\nMNG -> OPT_PARAM_FUN")*/ }
	;

OPERADOR_ARITMETICO: 
	  '+'				{ /*printf("\nMNG -> OPERADOR_ARITMETICO")*/ }
	| '-'			{ /*printf("\nMNG -> OPERADOR_ARITMETICO")*/ }
	| '*'		{ /*printf("\nMNG -> OPERADOR_ARITMETICO")*/ }
	| '/'			{ /*printf("\nMNG -> OPERADOR_ARITMETICO")*/ }
	| '^'			{ /*printf("\nMNG -> OPERADOR_ARITMETICO")*/ }
	| '%' 			{ /*printf("\nMNG -> OPERADOR_ARITMETICO")*/ }
	;

OPERADOR_LOGICO: 
	  '=' '=' 		{ /*printf("\nMNG -> OPERADOR_LOGICO")*/ }
	| '<' '>' 		{ /*printf("\nMNG -> OPERADOR_LOGICO")*/ }
	| '>' '=' 	{ /*printf("\nMNG -> OPERADOR_LOGICO")*/ }
	| '<' '='	{ /*printf("\nMNG -> OPERADOR_LOGICO")*/ }
	| '>' 		{ /*printf("\nMNG -> OPERADOR_LOGICO")*/ }
	| '<' 		{ /*printf("\nMNG -> OPERADOR_LOGICO")*/ }
	| '!' '=' 		{ /*printf("\nMNG -> OPERADOR_LOGICO")*/ }
	;

OPT_DECLARACION_LOGICA: 
	  Y_O DECLARACION_LOGICA OPT_DECLARACION_LOGICA		{ /*printf("\nMNG -> OPT_DECLARACION_LOGICA")*/ } 
	| /* VACIO */										{ /*printf("\nMNG -> OPT_DECLARACION_LOGICA")*/ }
	;

Y_O: 
	  Y 	{ /*printf("\nMNG -> Y_O")*/ }
	| O		{ /*printf("\nMNG -> Y_O")*/ }
	;

DECLARACION_SINO: 
	  SINO SINO_P	{ /*printf("\nMNG -> DECLARACION_SINO")*/ }
	| /* VACIO */	{ /*printf("\nMNG -> DECLARACION_SINO")*/ }
	;

SINO_P: 
	  DECLARACION_SI 			{ /*printf("\nMNG -> SINO_P")*/ }
	| '{' OPT_ARGS '}'	{ /*printf("\nMNG -> SINO_P")*/ }
	;

DECLARACION_PARA: 
	  PARA '(' PARA_1';' PARA_2 ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| error PARA '(' PARA_1';' PARA_2 ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| error '(' PARA_1';' PARA_2 ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA error '(' PARA_1';' PARA_2 ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA error PARA_1';' PARA_2 ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' error PARA_1';' PARA_2 ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' error ';' PARA_2 ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 error ';' PARA_2 ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 error PARA_2 ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' error PARA_2 ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' error ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' PARA_2 error ';' PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' PARA_2 error PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' PARA_2 ';' error PASO ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' PARA_2 ';' error ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' PARA_2 ';' PASO error  ')' '{' OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' PARA_2 ';' PASO error OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' PARA_2 ';' '{' PASO error OPT_ARGS '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' PARA_2 ';' '{' PASO error '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	| PARA '(' PARA_1 ';' PARA_2 ';' '{' PASO OPT_ARGS error '}'	{ /*printf("\nMNG -> DECLARACION_PARA")*/ }
	;

PARA_1:
	  ID_EL
	| ID_EL '=' V_ENTERO
	| ID_EL '=' V_ENTERO
	| ID_EL '=' REAL
	| ENTERO ID_EL '=' V_ENTERO
	| REAL ID_EL '=' REAL
	;

PARA_2:
	  ID_EL '>' '=' V_ENTERO
	| ID_EL '>' '=' V_REAL
	| ID_EL '<' '=' V_ENTERO
	| ID_EL '<' '=' V_REAL
	| ID_EL '>' V_ENTERO
	| ID_EL '>' V_REAL
	| ID_EL '<' V_ENTERO
	| ID_EL '<' V_REAL
	;

PASO: 
	  '+' '+' ID_EL 	{ /*printf("\nMNG -> PASO")*/ }
	| '-' '-' ID_EL 	{ /*printf("\nMNG -> PASO")*/ }
	| ID_EL '+' '+'	{ /*printf("\nMNG -> PASO")*/ }
	| ID_EL '-' '-'	{ /*printf("\nMNG -> PASO")*/ }
	| ID_EL ASIGNAR_EL ID_EL '+' '+'
	| ID_EL ASIGNAR_EL ID_EL '-' '-'
	| ID_EL ASIGNAR_EL '+' '+' ID_EL 
	| ID_EL ASIGNAR_EL '-' '-' ID_EL 
	| ID_EL ASIGNAR_EL ID_EL OPERADOR_ARITMETICO ID_EL
	| ID_EL ASIGNAR_EL ID_EL OPERADOR_ARITMETICO V_ENTERO
	| ID_EL ASIGNAR_EL ID_EL OPERADOR_ARITMETICO V_REAL
	;




DECLARACION_MIENTRAS_QUE:
	  MIENTRAS_QUE '(' DECLARACION_LOGICA OPT_DECLARACION_LOGICA ')' '{' OPT_ARGS '}' { /*printf("\nMNG -> DECLARACION_MIENTRAS_QUE")*/ }
	;						

DECLARACION_HACER_HASTA:
	  HACER '{' OPT_ARGS '}' MIENTRAS_QUE '(' DECLARACION_LOGICA OPT_DECLARACION_LOGICA ')' { /*printf("\nMNG -> DECLARACION_HACER_HASTA")*/ }
	;

DECLARACION_DEPENDIENDO_DE:
	  DEPENDIENDO_DE '(' ID_EL ')' '{' OPT_CASOS '}' { /*printf("\nMNG -> DECLARACION_DEPENDIENDO_DE")*/ }
	;

OPT_CASOS:
	  DECLARACION_CASO OPT_CASO { /*printf("\nMNG -> OPT_CASOS")*/ }
	;

DECLARACION_CASO: 
	  CASO CASO_P ':' OPT_ARGS P_BREAK	{ /*printf("\nMNG -> DECLARACION_CASO")*/ }
	;

CASO_P: 
	  V_ENTERO 	{ /*printf("\nMNG -> CASO_P")*/ }
	| V_REAL	{ /*printf("\nMNG -> CASO_P")*/ }
	;

P_BREAK: 
	  INTERRUMPIR ';' 	{ /*printf("\nMNG -> P_BREAK")*/ }
	| /**/ 				{ /*printf("\nMNG -> P_BREAK")*/ }
	;

OPT_CASO: 
	  DECLARACION_CASO OPT_CASO { /*printf("\nMNG -> OPT_CASO")*/ }
	| /**/						{ /*printf("\nMNG -> OPT_CASO")*/ }
	;

DECLARACION_LLAMAR_FUN: 
	  DECLARACION_USAR_FUN ';'	{ /*printf("\nMNG -> DECLARACION_LLAMAR_FUN")*/ }
	;

DECLARACION_ASIGNAR_A_VAR: 
	  ID_EL ASIGNAR_EL VAR_1 ';'	{ /*printf("\nMNG -> DECLARACION_ASGINAR_A_VAR")*/ }
	;

VAR_1: 
	  DECLARACION_USAR_VAR 	{ /*printf("\nMNG -> VAR_1")*/ }
	| PARAM_FUN 			{ /*printf("\nMNG -> VAR_1")*/ }
	;

DECLARACION_USAR_VAR: 
	  PARAM_FUN VAR_2	{ /*printf("\nMNG -> DECLARACION_USAR_VAR")*/ }
	;

VAR_2: 
	  OP_L_O PARAM_FUN 			{ /*printf("\nMNG -> VAR_2")*/ }
	| OP_L_A PARAM_FUN MAS_MAT	{ /*printf("\nMNG -> VAR_2")*/ }
	;

OP_L_O: 
	  OPERADOR_LOGICO	{ /*printf("\nMNG -> OP_L_O")*/ }
	| Y_O				{ /*printf("\nMNG -> OP_L_O")*/ }
	| '!'				{ /*printf("\nMNG -> OP_L_O")*/ }
	;

OP_L_A: 
	  OPERADOR_ARITMETICO	{ /*printf("\nMNG -> OP_L_A")*/ }
 	;

MAS_MAT: 
	  OP_L_A PARAM_FUN MAS_MAT 	{ /*printf("\nMNG -> MAS_MAT")*/ }
	| /**/ 						{ /*printf("\nMNG -> MAS_MAT")*/ }
	;

ASIGNAR_EL: 
	  '=' { /*printf("\nMNG -> ASGINAR_EL")*/ }
	| L_ERROR { }
	;

%% 

extern int yylex();
extern int yyparse();
extern void print_in_lex();
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;

char** str_split(char* a_str, const char a_delim)
{
    char** result    = 0;
    size_t count     = 0;
    char* tmp        = a_str;
    char* last_comma = 0;
    char delim[2];
    delim[0] = a_delim;
    delim[1] = 0;

    /* Count how many elements will be extracted. */
    while (*tmp)
    {
        if (a_delim == *tmp)
        {
            count++;
            last_comma = tmp;
        }
        tmp++;
    }

    /* Add space for trailing token. */
    count += last_comma < (a_str + strlen(a_str) - 1);

    /* Add space for terminating null string so caller
       knows where the list of returned strings ends. */
    count++;

    result = malloc(sizeof(char*) * count);

    if (result)
    {
        size_t idx  = 0;
        char* token = strtok(a_str, delim);

        while (token)
        {
            assert(idx < count);
            *(result + idx++) = strdup(token);
            token = strtok(0, delim);
        }
        assert(idx == count - 1);
        *(result + idx) = 0;
    }

    return result;
}

void yyerror(char *s) { 
    char** split = str_split(s, ',');
    char unexpected[30];
    strcpy(unexpected, split[1]+12);
    if(split[2]==NULL){
        
    }
    printf("\nLinea: %d: ERROR SINTACTICO, no se esperaba %s", yylineno, unexpected); 
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

void save(char *s){
	printf("\nERROR EN LA LINEA: %d, %s\n", yylineno, s);
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
	yyparse();
	print_in_lex();
	fclose(lex_out_file);
	fclose(fp);
	return(0);
}

