/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    MAIN = 258,
    ID = 259,
    V_CADENA = 260,
    V_ENTERO = 261,
    V_REAL = 262,
    VACIO = 263,
    ENTERO = 264,
    REAL = 265,
    CARACTER = 266,
    BOOLEANO = 267,
    SI = 268,
    SINO = 269,
    PARA = 270,
    HACER = 271,
    MIENTRAS_QUE = 272,
    DEPENDIENDO_DE = 273,
    CASO = 274,
    POR_DEFECTO = 275,
    INTERRUMPIR = 276,
    ESCRIBIR = 277,
    LEER = 278,
    RETORNAR = 279,
    VERDADERO = 280,
    FALSO = 281,
    ASIGNAR = 282,
    SUMAR = 283,
    SUMAR_1 = 284,
    RESTAR = 285,
    RESTAR_1 = 286,
    MULTIPLICAR = 287,
    DIVIDIR = 288,
    MODULO = 289,
    POTENCIA = 290,
    NEGAR = 291,
    MENOR_IGUAL_QUE = 292,
    MAYOR_IGUAL_QUE = 293,
    DIFERENTE_DE = 294,
    IGUAL_QUE = 295,
    MAYOR_QUE = 296,
    MENOR_QUE = 297,
    Y = 298,
    O = 299,
    PyC = 300,
    PP = 301,
    PAR_IZQ = 302,
    PAR_DER = 303,
    LLA_IZQ = 304,
    LLA_DER = 305,
    COR_IZQ = 306,
    COR_DER = 307,
    COMA = 308,
    L_ERROR = 309,
    E_O_F = 310
  };
#endif
/* Tokens.  */
#define MAIN 258
#define ID 259
#define V_CADENA 260
#define V_ENTERO 261
#define V_REAL 262
#define VACIO 263
#define ENTERO 264
#define REAL 265
#define CARACTER 266
#define BOOLEANO 267
#define SI 268
#define SINO 269
#define PARA 270
#define HACER 271
#define MIENTRAS_QUE 272
#define DEPENDIENDO_DE 273
#define CASO 274
#define POR_DEFECTO 275
#define INTERRUMPIR 276
#define ESCRIBIR 277
#define LEER 278
#define RETORNAR 279
#define VERDADERO 280
#define FALSO 281
#define ASIGNAR 282
#define SUMAR 283
#define SUMAR_1 284
#define RESTAR 285
#define RESTAR_1 286
#define MULTIPLICAR 287
#define DIVIDIR 288
#define MODULO 289
#define POTENCIA 290
#define NEGAR 291
#define MENOR_IGUAL_QUE 292
#define MAYOR_IGUAL_QUE 293
#define DIFERENTE_DE 294
#define IGUAL_QUE 295
#define MAYOR_QUE 296
#define MENOR_QUE 297
#define Y 298
#define O 299
#define PyC 300
#define PP 301
#define PAR_IZQ 302
#define PAR_DER 303
#define LLA_IZQ 304
#define LLA_DER 305
#define COR_IZQ 306
#define COR_DER 307
#define COMA 308
#define L_ERROR 309
#define E_O_F 310

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;
int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
