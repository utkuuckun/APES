
%{
  #include "parser.tab.h"
  #include <stdlib.h>
  void yyerror(char *);
%}

/*Basic Regular Expressions*/
CHAR [A-Za-z] 
DIGIT [0-9] 
MUL_OP [*/%] 
ADD_OP [+-] 


/*Identifier & Primitive Types*/

IDENTIFIER {CHAR}({CHAR}|{DIGIT})* 
Integer {DIGIT}+
Float {DIGIT}*(\.{DIGIT}|{DIGIT}\.){DIGIT}*
String \"([^\"\\\n]|\\\"|\\n|\\t|\\\\)*\"

%%

[ \t]+  ;

{Integer} return INTEGER;
{Float} return FLOAT;
True|False return BOOLEAN;
{ADD_OP} return ADD_OP;
{MUL_OP} return MUL_OP;

Oval return OVAL_TYPE;
Rectangle return RECTANGLE_TYPE;
Line return LINE_TYPE;
StringShape return STRING_SHAPE_TYPE;
Composite return COMPOSITE_TYPE;
draw return DRAW_FUNCTION;

Colour return COLOUR;
Location return LOCATION;
Size return SIZE;

if return IF;
else return ELSE;
do return DO;
while return WHILE;
for return FOR;

{IDENTIFIER} return IDENTIFIER;
{String} return STRING;
[<>{}()=,.;:\"\n] {return *yytext;}

. {yyerror("Unrecognized character");}
%%
  
/* Driver code */
int yywrap(void) {
  return 1;
}

