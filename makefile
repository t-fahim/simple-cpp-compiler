FILENAME=CPP
ANTLR_JAR=/usr/local/lib/antlr4.jar
CLASSPATH=.:$(ANTLR_JAR)

all:
	bison -d -y syntax_analyzer.y
	g++ -w -c y.tab.c -o y.o
	
	flex lex_analyzer.l
	g++ -fpermissive -w -c lex.yy.c -o l.o
	
	g++ y.o l.o -lfl -o compiler.out
	
	./compiler.out input.txt

	java -jar $(ANTLR_JAR) $(FILENAME).g4

	javac -cp $(CLASSPATH) *.java

	java -cp $(CLASSPATH) org.antlr.v4.gui.TestRig $(FILENAME) start -gui < input.txt

clean:
	rm -f *.java *.class *.tokens *.interp
	rm -f *.o y.tab.c y.tab.h lex.yy.c compiler.out