all: toy toyasm

toy: toy.o
	gcc -Wall -O2 toy.o -o toy

toyasm: main.c toy.tab.c lex.yy.c toy.tab.h
	gcc -o toyasm main.c toy.tab.c lex.yy.c

toy.tab.c: toy.y 
	bison -t -v -d -g --report=all toy.y

toy.tab.h: toy.y
	bison -d toy.y

lex.yy.c: toy.tab.h 
	flex toy.l

toy.o: 
	gcc -Wall -O2 -c toy.c

clean:
	rm -f toy toy.exe toyasm toyasm.exe toy.tab.* lex.yy.c *.o
