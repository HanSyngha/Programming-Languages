%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX  19
typedef struct abs{
	int loc;
	char* parent_id;
	char* my_id;
	char* text;
	struct abs *child[20];
}tree;
tree *AST[20];
extern int yylex(void);
extern void yyterminate();
extern int yyerror(const char *s);
void printpack(char *text1, char *text2);
void insert(char *parent_id, char *my_id, char *text, int loc);
void printall(int depth);
void printnode(tree *temp, int depth);
void yyprint(char *s);
void removestring(char* s);
void removetarget(char* s);
int isgoal = 1;
int wr = 0;
int rd = 0;
%}


%union{
	char* str;
}

%token <str> STRING MAIN FUN TYPE PACKAGE IMPORT IF ELSE FOR RETURN VAL	VAR CSTART CEND AS EOL SPACE LS LL LM RS RL RM SMC CHAR COLON COMMA DOLLAR DOT STAR SYMBOL PLUS MINUS EQUAL DIVIDE  NUMBER CONDITION

%type <str> printbody value mathsymbol varlhead functionvariable

%%
/* Rules */
goal:	eval goal	{}
  	|	eval		{}
	;
eval:	PACKAGE STRING DOT STRING { printpack($2,$4);
	}
	|	IMPORT importfun{ insert(NULL,"import",NULL,MAX); printall(2);
	}
	|	FUN funchead {removestring("func"); insert(NULL,"func",NULL,MAX); printall(2);
	}
	|	VAL varlhead{removestring("val"); insert(NULL,"val",NULL,MAX); printall(2);
	}
	|	VAR varlhead{removestring("var"); insert(NULL,"var",NULL,MAX); printall(2);
	}
	| 	arithmatic{insert(NULL,"arithmatic opperation",NULL,MAX); printall(2);
	}
	|	CSTART comment CEND	{printall(2); printf("\t\tcomment\n");
	}
	;
varlhead: 	STRING EQUAL NUMBER{insert("val","variable",$1,1); insert("val","variable","=",2); insert("val","variable",$3,3);  insert("var","variable",$1,1);  insert("var","variable","=",2);  insert("var","variable",$3,3); 
	}
	|	functionvariable EQUAL NUMBER{ insert("val","define",NULL,1); insert("val","variable","=",2); insert("val","variable",$3,3);  insert("var","define",NULL,1);  insert("var","variable","=",2);  insert("var","variable",$3,3); 
	}
	|	STRING COLON TYPE {insert("val","variable",$1,1); insert("val","variable",$3,2); insert("var","variable",$1,1); insert("var","variable",$3,2);
	}
	|	STRING EQUAL SMC printbody SMC {insert("val","variable",$1,1); insert("val","variable","=",2); insert("val","variable","text",3);  insert("var","variable",$1,1);  insert("var","variable","=",2);  insert("var","variable","text",3); 
	}
	;

funchead:	MAIN LS RS LM functionbody RM { insert("func","function name","main",1); insert("func","function body",NULL,2);
	}
	|	STRING LS functionvariable RS COLON TYPE LM functionbody RM {insert("func","function name",$1,1); insert("func","define",NULL,2); insert("func","function type",$6,3); insert("func","function body",NULL,4);
	}
	|	STRING LS functionvariable RS LM functionbody RM {insert("func","function name",$1,1); insert("func","define",NULL,2); insert("func","function body",NULL,3);
	}	
	|	STRING LS functionvariable RS EQUAL STRING mathsymbol STRING {insert("func","function name",$1,1); insert("func","define",NULL,2); insert("func","return value",NULL,3);
	}
	;
importfun: STRING DOT STRING DOT STAR{ insert("import","child",$1,1); insert("import","child",$3,2); insert("import","child","*",3);
	}
	|	STRING DOT STRING DOT STRING AS STRING{	insert("import","child",$1,1); insert("import","child",$3,2); insert("import","child",$5,3); insert("import","child","as",MAX); insert("import","child",$7,MAX); 
	}
	|	STRING DOT STRING DOT STRING{ insert("import","child",$1,1); insert("import","child",$3,2); insert("import","child",$5,3);
	}
	;
comment:	value comment{
	}
	|	value{
	}
	|	EOL comment|SPACE comment|LS comment|LL comment|LM comment|RS comment|RL comment|RM comment|SMC comment|CHAR comment|COLON comment|COMMA comment|DOLLAR comment|DOT comment|STAR comment|SYMBOL comment|PLUS comment|MINUS comment|EQUAL  comment {
	}
	|	EOL|SPACE|LS|LL|LM|RS|RL|RM|SMC|CHAR|COLON|COMMA|DOLLAR|DOT|STAR|SYMBOL|PLUS|MINUS|EQUAL {
	}
	;

functionvariable: STRING COLON TYPE COMMA functionvariable { insert("define","variable",$1,1); insert("define","variable",$3,2);
	}
	|	STRING COLON TYPE { insert("define","variable",$1,1); insert("define","variable",$3,2);
	}
	|	{
	}
	;
	
functionbody:	STRING LS SMC printbody SMC RS { insert("function body","call function",$1,1); insert("function body","argument","text",2); insert("if body","call function",$1,1); insert("if body","argument","text",2); insert("function body","argument","text",2); insert("else body","call function",$1,1); insert("else body","argument","text",2);
	}
	|	RETURN returnstring{ insert("function body","return value",NULL,MAX); insert("if body","return value",NULL,MAX); insert("else body","return value",NULL,MAX);
	}
	|	arithmatic{ insert("function body","arithmatic opperation",NULL,MAX); insert("if body","arithmatic opperation",NULL,MAX); insert("else body","arithmatic opperation",NULL,MAX);
	}
	|	IF  ifcondition LM  functionbody RM ELSE LM functionbody RM { insert("function body","if","if",1); insert("function body","if condition",NULL,2); insert("function body","if body",NULL,3); insert("function body","else","else",4); insert("function body","else body",NULL,5); 
	}
	;	
ifcondition: LS value CONDITION value RS{ insert("if condition","variable",$2,1); insert("if condition","variable",$3,2); insert("if condition","variable",$4,3);
	}
	;
arithmatic:	STRING EQUAL NUMBER{ insert("arithmatic opperation","symbol",$1,1); insert("arithmatic opperation","symbol","=",2); insert("arithmatic opperation","symbol",$3,MAX);
	}
	|	STRING mathsymbol EQUAL NUMBER{ insert("arithmatic opperation","symbol",$1,1); insert("arithmatic opperation","symbol",$2,2);insert("arithmatic opperation","symbol","=",3); insert("arithmatic opperation","symbol",$4,4);
	}
	;

printbody: value printbody{
	}
	|	DOLLAR LM  returnstring RM printbody{
	}
	|	DOLLAR value printbody{
	}
	|	DOLLAR LM returnstring RM{
	}
	|	DOLLAR value{
	}
	|	value SYMBOL{ strcat($$,$1); strcat($$,$2);
	}
	|	value{ $$ = $1;
	}
	;
returnstring:	value mathsymbol returnstring{
	}
	|	value{
	}
	;
value: STRING{ $$ = $1;
	}
	|	NUMBER{ $$ = $1;
	}
	;
mathsymbol: PLUS{ $$ = "+";
	}
	|	MINUS{ $$ = "-";
	}
	|	STAR{ $$ = "*";
	}
	| 	DIVIDE{ $$ = "/";
	}
	;
	
%%
/* User code */
int yyerror(const char *s)
{
	return printf("%s\n", s);
}
void yyprint(char *s)
{
	printf("%s\n",s);
}
void printpack(char *text1,char *text2)
{
	if(isgoal)
	{
		printf("root\n");
		isgoal = 0;
	}
	printf("\tpackage\n\t\tpackage-child(%s,$2)\n\t\tpackage-child(%s,$4)\n",text1,text2);
}
void insert(char *parent_id, char *my_id, char *text, int loc)
{
	tree *temp = (tree*)malloc(sizeof(tree));
	int i;
	int cnt;
	int write = 0;
	for(i=0;i<20;i++) temp->child[i] = NULL;
	for(cnt=0;cnt<20;cnt++)
	{
		if(AST[cnt] == NULL)
		{
			continue;
		}
		if(strcmp(AST[cnt]->parent_id,my_id) == 0)
		{
			temp->child[write++] = AST[cnt];
			if(strcmp(my_id,"if body") == 0) removetarget("if body");
			if(strcmp(my_id,"else body") == 0) removetarget("else body");
			//if(strcmp(my_id,"function body") == 0) removetarget("function body");
			AST[cnt] = NULL;
		}
	}
	if(parent_id == NULL) temp->parent_id = NULL;
	else{
		temp->parent_id = (char*)malloc(strlen(parent_id));
		for(i=0;i<strlen(parent_id);i++) temp->parent_id[i] = parent_id[i];
		temp->parent_id[i] = '\0';
	}
	if(my_id == NULL) temp->my_id = NULL;
	else{
		temp->my_id = (char*)malloc(strlen(my_id));
		for(i=0;i<strlen(my_id);i++) temp->my_id[i] = my_id[i];
		temp->my_id[i] = '\0';
	}
	if(text == NULL) temp->text = NULL;
	else{
		temp->text = (char*)malloc(strlen(text));
		for(i=0;i<strlen(text);i++) temp->text[i] = text[i];
		temp->text[i] = '\0';
	}
	for(cnt=0;cnt<20;cnt++)
	{
		if(AST[cnt] == NULL) break;
	}
	temp->loc = loc;
	AST[cnt] = temp;
	/*for(cnt=0;cnt<20;cnt++)
	{
		if(AST[cnt] == NULL) printf("%d NULL\n",cnt);
		else printf("%d p:%s m:%s t:%s\n",cnt,AST[cnt]->parent_id,AST[cnt]->my_id,AST[cnt]->text);
	}*/
}
void printall(int depth)
{
	if(isgoal)
	{
		printf("root\n");
		isgoal = 0;
	}
	int i;
	tree *temp;
	for(i=0;i<20;i++)
		{
			temp = AST[i];
			if(temp != NULL) printnode(temp,depth);
		}
	for(i=0;i<20;i++) AST[i] = NULL;
	wr = 0;
	rd = 0;
}
void printnode(tree *temp, int depth)
{
	int i,j;
	for(i=0;i<depth;i++) printf("\t");
	if(temp->parent_id != NULL) printf("%s-",temp->parent_id);
	if(temp->my_id != NULL) printf("%s",temp->my_id);
	if(temp->text != NULL) printf("(%s)",temp->text);
	printf("\n");
	for(j=0;j<20;j++)for(i=0;i<20;i++) if(temp->child[i] != NULL && temp->child[i]->loc == j) printnode(temp->child[i],depth+1);
}

void removestring(char* s)
{
	int i;
	for(i=0;i<20;i++)
	{
		if(AST[i] == NULL) continue;
		if(strcmp(AST[i]->parent_id,s) != 0)
		{
			AST[i] = NULL;
		}
	}		
}

void removetarget(char* s)
{
	int i;
	for(i=0;i<20;i++)
	{
		if(AST[i] == NULL) continue;
		if(strcmp(AST[i]->parent_id,s) == 0)
		{
			AST[i] = NULL;
		}
	}		
}
