#include <list> 
#include <iterator> 

using namespace std;

#ifndef RUBIKS_H
#define RUBIKS_H

#define Y 0
#define B 1
#define R 2
#define G 3
#define O 4
#define W 5


class Move{
    public:
        char face;
        bool inverted;
        int quarterTurns;
        Move();
        Move(char face, bool inverted, int quarterTurns);
        void setMove(char face, bool inverted, int quarterTurns);
        char getFace() {return face;};
        bool getInverted(){return inverted;};
        int getQuarterTurns(){return quarterTurns;};
        friend std::ostream& operator<<(std::ostream& os, const Move& p)
        {
            return os << "("
                  << p.face << ", "
                  << p.inverted << ", "
                  << p.quarterTurns
                  << ")";
        }
};

class Rubiks {
    public:
        int state[6][3][3] =
        {
                {{Y,Y,Y},{Y,Y,Y},{Y,Y,Y}},
                {{B,B,B},{B,B,B},{B,B,B}},
                {{R,R,R},{R,R,R},{R,R,R}},
                {{G,G,G},{G,G,G},{G,G,G}},
                {{O,O,O},{O,O,O},{O,O,O}},
                {{W,W,W},{W,W,W},{W,W,W}},
         };
        char adjacent[6][4]
        {
            {O, G, R, B},
            {Y, R, W, O},
            {Y, G, W, B},
            {Y, O, W, R},
            {Y, B, W, G},
            {R, G, O, B},
        };
        std::list <Move> scramble;
        Rubiks();
        Rubiks(list <Move> scramble);
        void setScramble(list <Move> scramble);
        void doMove(Move move);
        void doScramble(list<Move> scramble);
        void printCube();
        std::list <Move> getScramble() {return scramble;}
    private:
        int intOfFace(char face);
        void rotateFace(int face, bool clockwise);
        void rotateAdjacent(int face, bool clockwise);
};  

#endif
