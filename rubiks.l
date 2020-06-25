%{
#include <stdlib.h>
#include <iostream>
#include "rubiks.tab.h"
#include<string.h>
extern "C" int yylex(void);
using namespace std;
%}
%option yylineno
/*
tipos de movimiento:
    cara-> rotación de 90º de la respectiva cara
    multi-> rotación de 90º de 2 "secciones" del lado respectivo
    cubo-> rotación de 90º del cubo entero sobre el eje indicado(mayúscula o minúscula)
 */
cara F|B|R|L|U|D 
multi f|b|r|l|u|d
cubo X|Y|Z|x|y|z

/*
Una secuencia de movimientos puede estar entre paréntesis seguido de xN donde N
son las veces que ésta se repite, por ejemplo: (R U R' U')x2.
El token CLOSE_BR pasa ese valor de repeticion al parser
*/
open "("
close ")x"[0-9]

/*
modificadores de movimientos:
    inverso-> rotación en sentido inverso
    doble-> rotación de 180º
    modMulti-> igual que "multi" arriba, pero se puede anotar como un giro
                normal de 90º seguido de 'w'. P.ej, Rw = r
*/
inverso '|i
doble 2
modMulti w

%%
{cara} {yylval.valChar = *yytext; return CARA;}
{multi} {yylval.valChar = *yytext; return MULTI;}
{cubo}  {yylval.valChar = *yytext; return CUBO;}

{open}  {return OPEN_BR;}
{close}  {yylval.valChar = yytext[2];return CLOSE_BR;}

{inverso} {yylval.valChar = *yytext; return INVERSO;}
{doble} {yylval.valChar = *yytext; return DOBLE;}
{modMulti} {yylval.valChar = *yytext; return MODMULTI;}

\n ;
. ;
%%
