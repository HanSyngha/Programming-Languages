%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node{
	char* word;
	double val;
	struct node* next;
}Node;

Node* Head = NULL;

extern int yylex(void);
extern void yyterminate();
extern int yyerror(const char *s);
extern Node* yyinsert(Node* Head,char *s, double val);
extern double yyfind(Node* Head, char *s);
%}


%union{
	char exp;
	char* str;
	double num;
}

%token <num> NUMBER
%token <str> ID
%token <exp> EOL EQUAL 
%left  <exp> PLUS MINUS
%left  <exp> MULT DIV
%left  <exp> L R

%type <str> eval
%type <num> expr term factor charactor

%%
/* Rules */
goal:	eval goal	{}
    |	eval		{}
	;
eval:	expr EOL	{ printf("%lf\n",$1);
    	}
    |	charactor EOL	{} 
    ;
expr:	expr PLUS term	{ $$ = $1 + $3;
    	}
    |	expr MINUS term	{ $$ = $1 - $3;
	} 
    |	expr PLUS PLUS term	{ $$ = $1 + $4;
    	}
    |	expr PLUS MINUS term	{ $$ = $1 - $4;
	}
    |	expr MINUS PLUS term	{ $$ = $1 - $4;
    	}
    |	expr MINUS MINUS term	{ $$ = $1 + $4;
	}
    |	term		{ $$ = $1;
	} 
    ;
term:	term MULT factor { $$ = $1 * $3;
    	} 
    |	term DIV factor	{ $$ = $1 / $3;
	} 
    |	factor		{ $$ = $1;
	}
    ;
factor: NUMBER	{ $$ = $1;
        }
    |	ID	{ $$ = yyfind(Head, $1);
	}	
    | 	L expr R { $$ = $2;
	}	
    ;
charactor: ID EQUAL NUMBER {  Head = yyinsert(Head, $1, $3); $$ = $3;
	   }
	|  ID EQUAL PLUS NUMBER {  Head = yyinsert(Head, $1, $4); $$ = $4;
	   }
	|  ID EQUAL MINUS NUMBER {  Head = yyinsert(Head, $1, $4); $$ = -$4;
	   }
;

%%
/* User code */
int yyerror(const char *s)
{
	return printf("%s\n", s);
}

double yyfind(Node* Head, char *s)
{
	if(Head == NULL)
	{
		yyerror("No ID Recorded!\n");
		return 0;
	}
	Node* find = Head;
	while(find->next != NULL)
	{
		if(*(find->word) == *s) return find->val;
		find = find->next;
	}
	yyerror("No ID Recorded!\n");
	return 0;
}

Node* yyinsert(Node* Head,char *s, double val)
{	
	Node* temp = (Node*)malloc(sizeof(Node));
	temp->word = (char*)malloc(sizeof(char)*(strlen(s)+1));
	int i = 0;
	for(i = 0;s[i] != '\0';i++)
	{
		temp->word[i] = s[i];
	}
	temp->word[i] = '\0';
	temp->val = val;
	temp->next = NULL;
	if(Head == NULL)
	{
		Head = temp;
	}
	else
	{
		Node *find = Head;
		while(find->next != NULL)
		{
			if(*(find->word) == *s)
			{
				find->val = val;
				return Head;
			}
			find = find->next;
		}
		find->next = temp;
	}
	return Head;
}
