%{
#include <stdlib.h>
#include <string.h>

#include "expr.tab.h"

extern int yyerror(const char*);
%}

NUMBER [1-9]?[0-9]+\.?[0-9]+?
ID [a-zA-Z][a-zA-Z0-9]*
SPACE [ \t\r\n]+

%%
{ID} { yylval.str = strndup(yytext, yyleng);\
	return ID;
}

{NUMBER} { 	double temp;
		sscanf(yytext,"%lf",&temp);
		yylval.num = temp;
	return NUMBER;
}

"+"	{ return PLUS; 
}

"-"	{ return MINUS;
}

"*"	{ return MULT; 
}

"/"	{ return DIV;
}

"=" 	{ return EQUAL;
}

"("	{ return L;
}

")"	{ return R;
}

";"	{ return EOL;
}

{SPACE} { 
	/* ignore */ 
}



%%
/* User code */




