%{
#include <stdlib.h>
#include <string.h>

#include "kotlin.tab.h"

extern int yyerror(const char*);
%}

NUMBER [+|-]?[1-9]?[0-9]*[.]?[0-9]*?
STRING [0-9]*?[a-zA-Z][a-zA-Z0-9]*
CHAR [a-zA-Z]
SPACE [\t|\r|\n]
IGNORE[ ]
SMC ["]
SYMBOL [!]
CONDITION [=|>|<]+

%%
"package" return PACKAGE;
"import" return IMPORT;
"main" return MAIN;
"fun" return FUN;
"if" return IF;
"else" return ELSE;
"For" return FOR;
"return" return RETURN;
"val" return VAL;
"var" return VAR;
"as" return AS;
"." return DOT;
":" return COLON;
"," return COMMA;
"$" return DOLLAR;
"*" return STAR;
";" return EOL;
"(" return LS;
")" return RS;
"{" return LM;
"}" return RM;
"[" return LL;
"]" return RL;
"+" return PLUS;	
"/" return DIVIDE;
"-" return MINUS;
"/*" return CSTART;
"*/" return CEND;



{STRING} { yylval.str = strndup(yytext, yyleng);
	if(strcmp(yylval.str,"Int") == 0 || strcmp(yylval.str,"Unit") == 0 || strcmp(yylval.str,"Any") == 0 || strcmp(yylval.str,"Long") == 0 || strcmp(yylval.str,"String") == 0 || strcmp(yylval.str,"Double") == 0 || strcmp(yylval.str,"Boolean") == 0 ) return TYPE;
	else return STRING;
}

{CONDITION} { yylval.str = strndup(yytext, yyleng);
	if(strcmp(yylval.str,"==") == 0 || strcmp(yylval.str,"<=") == 0 || strcmp(yylval.str,">=") == 0 || strcmp(yylval.str,">") == 0 || strcmp(yylval.str,"<") == 0 ) return CONDITION;
	if(strcmp(yylval.str,"=") == 0 ) return EQUAL;
}

{NUMBER} { yylval.str = strndup(yytext, yyleng);
	return NUMBER;
}



{SMC} {
	return SMC;
}

{SYMBOL} {
	return SYMBOL;
}


{SPACE} { 
}
{IGNORE} {
}



%%
/* User code */




