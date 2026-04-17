all:
	bison -d -y syntax_analyzer.y
	g++ -w -c y.tab.c -o y.o
	
	flex lex_analyzer.l
	g++ -fpermissive -w -c lex.yy.c -o l.o
	
	g++ y.o l.o -lfl -o compiler.out
	
	./compiler.out input.txt

clean:
	# Added my_log.txt, tac.txt, and assembly.txt to the cleanup list
	rm -f *.o y.tab.c y.tab.h lex.yy.c compiler.out my_log.txt tac.txt assembly.txt

