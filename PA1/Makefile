#Makefiel for expression calculator

TARGET=calc
CFG=expr
LEX_SRC=$(CFG).l
YACC_SRC=$(CFG).y
SRC=main.c

all:
		flex $(LEX_SRC)
		bison -d $(YACC_SRC) 
		gcc -o $(TARGET) $(CFG).tab.c lex.yy.c $(SRC) -lfl

clean:
		rm -f lex.yy.c $(CFG).tab.c $(CFG).tab.h $(TARGET)
