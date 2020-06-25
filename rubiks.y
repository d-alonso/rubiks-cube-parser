%{
#include <iostream>
#include <cctype>
#include <cstring>
#include <vector>
#include <stack>
#include "rubiks.h"
#include <list>
#define YYDEBUG 1

using namespace std;

extern int yylineno;
//yylineno es la variable por defecto de contador de linea, hay que declararla como
//extern int yylineno; en bison
//y activarla como "%option yylineno" en flex
void yyerror(const char *error);

//esta declaración es necesaria para usar C++ con la versión de flex/bison en C.
extern "C"{
		int yyparse(void);
		int yylex(void);  
        int yywrap()
        {
                return 1;
        }
}
list<Move> moveList;

Move createMove(char tipo, char mod){
	char face = tipo;
	bool isInverted = (mod=='i');
	int quarterTurns = 1;
	if (mod=='w') face = tolower(face);
	if (mod=='2') quarterTurns = 2;
	Move move(face, isInverted , quarterTurns);
	return move;
}

Move optimizeMoves(char tipo, char mod, bool * wasOptimized){
	*wasOptimized = false;
	if (moveList.empty()){/*checkear si lista vacía*/
		return createMove(tipo, mod);
	}
	else{
		Move lastMove = moveList.back();
		char face = tipo;
		if (mod =='w') face = tolower(face);
		if (lastMove.getFace()!=face){/* solo optimizaciones triviales(misma cara)*/
			return createMove(tipo, mod);
		}
		else{
			*wasOptimized = true;
			int totalRotations = 0;
			char toPrintLastMoveMod;
			if (mod =='2') totalRotations += 2;
			if (mod =='i') totalRotations += -1;
			if (mod ==' ') totalRotations += 1;
			if (lastMove.getInverted()) 
				{totalRotations += -1;toPrintLastMoveMod='i';}
			else 
				{ int turns = lastMove.getQuarterTurns();
				totalRotations += turns;
				if (turns==2) toPrintLastMoveMod='2';}

			printf("\nMovimiento optimizado[%c%c %c%c]",
			lastMove.getFace(), toPrintLastMoveMod, face, mod);


			switch (totalRotations){
				case 0:
				case 4:{/* 4 rotaciones = 0 en un cubo. Devuelve un move vacío*/
					Move emptyMove;
					return emptyMove;
					break;
				}
				case 1:{ /* rotar 2 veces y luego una en sentido inverso = rotar 1 vez */
					Move newmove(face,false,1);
					return newmove;
					break;
				}
				case  2:
				case -2:{/* no importa la dirección al rotar 2 veces*/
					Move newmove(face,false,2);
					return newmove;
					break;
				}
				case 3: {/* rotar 3 veces en una dirección = rotar 1 vez en la opuesta*/
					Move newmove(face,true,1);
					return newmove;
					break;
				}
			}
		}
	}
}


%}
%expect 6
%code requires{
	#include "rubiks.h"
}
%union{
	char valChar;
	list<Move>* valMoveList;
}

%token 	<valChar> CARA MULTI CUBO 
%token <valChar> OPEN_BR CLOSE_BR
%token <valChar> INVERSO DOBLE MODMULTI
%type <valChar> tipo mod errorModMulti
%type <valMoveList> move

%error-verbose
%define parse.trace

%start S

%%

S : move {cout << "\nLista final de movimientos: \n";
		for (auto v : moveList)
	        std::cout << v << "\n";}
;

move:	{$$ = new list<Move>;/*primero*/}
;
		|move OPEN_BR move{/* evita error de parentesis abiertos*/
						yyerror("Falta paréntesis de cierre, se interpretarán los movimientos una vez igualmente");}
;
		|move OPEN_BR move CLOSE_BR
				{	int repeat = $4 - '0' - 1;/* -1 vez por ser añadido en ejecución normal*/
					for (int i = 0; i <repeat; i++) {
        				moveList.insert(moveList.end(), $3->begin(), $3->end());
					};
					delete $3;
					printf("Se repiten %c veces\n",$4);
				}
;
		
 		|move tipo mod 
					{ /*movimiento con modificador*/
						bool wasOptimized;
						printf("Movimiento: %c%c",$2,$3);
						Move move = optimizeMoves($2,$3,&wasOptimized);
						if(wasOptimized){ 
						/* eliminar el movimiento previo si fue optimizado */
							moveList.pop_back();
							if (!$1->empty()) $1->pop_back();
						}
						if (move.getQuarterTurns()){ 
							/*para las optimizaciones que eliminan ambos movimientos*/
							cout << move << "\n";
							moveList.push_back(move);
							$1->push_back(move); $$=$1;
						}
						else{
							printf(": Anulados\n");
						}
					}
;
		|move tipo {	/*movimiento sin modificador*/
						bool wasOptimized;
						printf("Movimiento: %c ",$2);
						Move move = optimizeMoves($2,' ',&wasOptimized);
						if(wasOptimized){ 
						/* eliminar el movimiento previo si fue optimizado */
							moveList.pop_back();
							if (!$1->empty()) $1->pop_back();
						}
						if (move.getQuarterTurns()){
							/*para las optimizaciones que eliminan ambos movimientos*/
							cout << move << "\n";
							moveList.push_back(move);
							$1->push_back(move); $$=$1;
						}
						else{
							printf(": Anulados\n");
						}
					}
;

		| move error {yyerrok;yyclearin;$$=$1;}
;
		
		| move errorModMulti {
							char e[512];
							sprintf(e,"No se puede aplicar el  modificador de capas múltiples a \"%c\", solo se puede aplicar a rotaciones de una sola cara(F,B,U,D,R,L)",$2);
					yyerror(e);$$=$1;
							}
;

tipo: CARA{$$ = $1;}
	| CARA MODMULTI{$$ = tolower($1);}
	| MULTI {$$ = $1;}
	| CUBO {$$ = $1;}
;

mod : INVERSO {$$ = 'i';}
	| doble {$$ = '2';}
;

doble : DOBLE 
	| DOBLE INVERSO
	| INVERSO DOBLE
;
errorModMulti : MULTI MODMULTI {$$ = $1;}
	| CUBO MODMULTI {$$ = $1;}

%%
int main(int argc, char *argv[]) {
	extern FILE *yyin;
	Rubiks rubik;

	switch (argc) {
		case 1:	yyin=stdin;
			yyparse();
			rubik.doScramble(moveList);
			break;
		case 2: yyin = fopen(argv[1], "r");
			if (yyin == NULL) {
				printf("ERROR: No se ha podido abrir el fichero.\n");
			}
			else {
				yyparse();
				fclose(yyin);
				rubik.doScramble(moveList);
			}
			break;
		default: printf("ERROR: Demasiados argumentos.\nSintaxis: %s [fichero_entrada]\n\n", argv[0]);
	}

	return 0;
}
void yyerror (char const *message) { fprintf (stderr, "Error en la línea %d: %s\n", yylineno, message);}

	
