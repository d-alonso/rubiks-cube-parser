#include <iostream>
#include <list> 
#include <algorithm>
#include <iterator>
#include <cstring>
#include "rubiks.h"

using namespace std;

Move::Move(char f, bool i, int qT)
{
  setMove(f, i, qT);
}

Move::Move()
{
    setMove(' ', false, 0);
};

void Move::setMove(char f, bool i, int qT)
{
  face = f;
  inverted = i;
  quarterTurns = qT;
}

Rubiks::Rubiks()
{

};

void Rubiks::doMove(Move move){
    int numberOfTurns = move.getQuarterTurns();
    for (int i =0; i < numberOfTurns; i++){
        int face = Rubiks::intOfFace(move.getFace());
        bool inverted = move.getInverted();
        Rubiks::rotateFace(face, inverted);
        Rubiks::rotateAdjacent(face,inverted);
            
    }
}


int Rubiks::intOfFace(char face){
    switch (face){
        case 'F':
            return R;
        case 'B':
            return O;
        case 'R':
            return G;
        case 'L':
            return B;
        case 'U':
            return Y;
        case 'D':
            return W;
    }
}

void Rubiks::rotateFace(int face, bool clockwise){
    int old_state[6][3][3];
    memcpy(old_state, state, sizeof(int)*6*3*3);
    for (int i=0; i<3; i++){
        for (int j=0; j<3; j++){
            state[face][i][j] = clockwise ? old_state[face][j][2-i] : old_state[face][2-j][i];
        }
    }
}

void Rubiks::rotateAdjacent(int face, bool inverted){
    int old_state[6][3][3];
    memcpy(old_state, state, sizeof(int)*6*3*3);
    
    if (!inverted){
        for (int i=0; i<3; i++){
            state[adjacent[face][0]][2][i] = old_state[adjacent[face][3]][2-i][2];
        }
        for (int i=0; i<3; i++){
            state[adjacent[face][1]][i][0] = old_state[adjacent[face][0]][2][i];
        }
        for (int i=0; i<3; i++){
            state[adjacent[face][2]][0][i] = old_state[adjacent[face][1]][2-i][0];
        }
        for (int i=0; i<3; i++){
            state[adjacent[face][3]][i][2] = old_state[adjacent[face][2]][0][i];
        }
    }
    else{
        for (int i=0; i<3; i++){
            state[adjacent[face][0]][2][i] = old_state[adjacent[face][1]][i][0];
        }
        for (int i=0; i<3; i++){
            state[adjacent[face][1]][i][0] = old_state[adjacent[face][2]][0][2-i];
        }
        for (int i=0; i<3; i++){
            state[adjacent[face][2]][0][i] = old_state[adjacent[face][3]][i][2];
        }
        for (int i=0; i<3; i++){
            state[adjacent[face][3]][i][2] = old_state[adjacent[face][0]][2][2-i];
        }
    }
}

void Rubiks::printCube(){
    for (int x=0; x<6; x++){
        printf("Cara número %i\n",x);
        for (int i=0; i<3; i++){
            for (int j=0; j<3; j++){
            printf("%i ",state[x][i][j]);
            };printf("\n");
        }printf("\n");
    }
}


void Rubiks::doScramble(list<Move> scramble){
    printf("\nRealizando lista de movimientos...\n");
    for (Move m : scramble){
        doMove(m);
        printCube();
        printf("*************************************************************\n");

    }
}

/*
int main(){
    list<Move> moveList;
    Move move('R', false, 2);
    moveList.push_back(move);
    for (auto v : moveList)
	        std::cout << v << "\n";
    Rubiks rubik;

    rubik.doScramble(moveList);
}*/


