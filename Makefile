FUENTE = rubiks
PRUEBA = ejemplo_rubiks.txt

all: compile run

flex:
	flex $(FUENTE).l
	g++ -o $(FUENTE) lex.yy.c -lfl
	./$(FUENTE) < $(PRUEBA)

compile:
	flex $(FUENTE).l
	bison -o $(FUENTE).tab.c $(FUENTE).y -d -v
	g++ -o $(FUENTE) lex.yy.c $(FUENTE).tab.c rubiks.cpp -lfl

run:
	./$(FUENTE) < $(PRUEBA)

run2:
	./$(FUENTE) $(PRUEBA)

clean:
	rm $(FUENTE) lex.yy.c $(FUENTE).tab.c $(FUENTE).tab.h

