%{ 
#include <stdio.h>
#include <stdlib.h>
#include <string>
void yyerror(char *);
int yylex(void);
#define YYSTYPE std::string
%}



//Definitions
%token BOOLEAN INTEGER FLOAT
%token OVAL_TYPE RECTANGLE_TYPE LINE_TYPE STRING_SHAPE_TYPE COMPOSITE_TYPE DRAW_FUNCTION 
%token COLOUR LOCATION SIZE
%token IF ELSE DO WHILE FOR
%token ADD_OP
%token MUL_OP
%token STRING IDENTIFIER

%%

start: controlExpr  '\n' start
	| statement ';' '\n' start
	| error  start
	| '\n' start
	|
	;

statement: arithmeticAssign
	| shapeAssign
	| shapeDraw
	| StringAssign
	| colourAssign
	| locationAssign
	| sizeAssign
	;

colourAssign: IDENTIFIER '=' COLOUR '(' INTEGER ',' INTEGER ',' INTEGER ')' {printf("colourAssign \n");}


sizeAssign: IDENTIFIER '=' SIZE '(' INTEGER ',' INTEGER ')' {printf("sizeAssign \n");}

locationAssign:	IDENTIFIER '=' LOCATION '(' INTEGER ',' INTEGER ')' {printf("locationAssign \n");}


StringAssign: IDENTIFIER '=' STRING {printf("IDENTIFIER '=' STRING \n");}

arithmeticAssign: 	
	IDENTIFIER '=' arithmeticExpr  {printf(" Arithmetic Assignment: IDENTIFIER = %s \n", $3.c_str()	);}
	;

arithmeticExpr:
	arithmeticExpr ADD_OP arithmeticTerm {  $$ = "( " + $1 +  " ADD_OP " + $3 +" )" ;}
	| arithmeticTerm			 {$$ = $1; }
	;

arithmeticTerm:
	arithmeticTerm MUL_OP numeric		 {  $$ = "( " + $1 +  " MUL_OP " + $3 + " )";}
	| numeric				{ $$ = $1.c_str();}
	;

numeric: 
	 IDENTIFIER { $$ = "IDENTIFIER";}
	| FLOAT  { $$ = "FLOAT";}
	| INTEGER   { $$ = "INTEGER";}
	;

shapeAssign:
	IDENTIFIER '=' Shape_Init {printf(" Shape Assignment: IDENTIFIER = %s \n", $3.c_str()	);}
	;

Shape_Init:
	ShapeType '(' parameters ')' {$$ = "ShapeType( " +$1 + " ) ( \nPARAMETERS: \n " + $3 + " \n)";}
	;

ShapeType: LINE_TYPE {$$ = "LINE_TYPE";}
	| OVAL_TYPE		{$$ = "OVAL_TYPE";}
	| RECTANGLE_TYPE {$$ = "RECTANGLE_TYPE";}
	| STRING_SHAPE_TYPE {$$ = "STRING_SHAPE_TYPE";}
	| COMPOSITE_TYPE  {$$ = "COMPOSITE_TYPE";}
	;	

shapeDraw:
 IDENTIFIER '.' DRAW_FUNCTION '(' parameters ')' {printf(" Shape Draw: IDENTIFIER.DRAW_FUNCTION (\nPARAMETERS:  %s \n )", $5.c_str() );}
	;

parameters:
	namedParams extendedNamedParams {$$ = $1 + $2;}
	| namedParams   {$$ = $1;}
	| normalParam {$$ = $1;}
	|normalParam extendedParams   {$$ = $1 + $2;}
	|
	;

	extendedNamedParams: 
	 ',' namedParams  {$$ = "," + $2;}
	| ',' namedParams extendedParams  {$$ = "," + $2 + $3.c_str() ;}
	;

extendedParams: 
	 ',' namedParams  {$$ = "," + $2;}
	| ',' namedParams extendedNamedParams {$$ = "," + $2 + $3;}
	| ',' normalParam extendedParams  {$$ = "," + $2 + $3.c_str() ;}
	| ',' normalParam  {$$ = "," +  $2;}
	;

normalParam:
	 STRING {$$ = "STRING";}
	| BOOLEAN {$$ = "BOOLEAN";}
	| INTEGER {$$ = "INTEGER";}
	| IDENTIFIER {$$ = "IDENTIFIER";}
	;

namedParams:
	IDENTIFIER ':' value  {$$ = "namedParam( name: value( " + $3 + " ) )";}
	;

value: STRING {$$ = "STRING";}
	| BOOLEAN {$$ = "BOOLEAN";}
	| INTEGER {$$ = "INTEGER";}
	| IDENTIFIER {$$ = "IDENTIFIER";}
	| {yyerror("Not a valid value");}
	;


controlExpr: IF '(' condition ')' '{'  start  '}' {printf("controlExpression: IF ( Condition ) { STATEMENT } \n");}
	| WHILE '(' condition ')' '{' start '}'		 {printf("controlExpression: WHILE (condition) { STATEMENT}\n");}
	| DO '{' start '}' WHILE '(' condition ')'     {printf("controlExpression: DO (STATEMENT) WHILE  { Condition} \n");}
	| FOR '(' arithmeticAssign ';' condition ';' arithmeticAssign ')'    {printf("controlExpression: FOR LOOP");}
	;

condition: 
	| numeric check numeric
	| IDENTIFIER '=' '=' BOOLEAN
	| BOOLEAN '=' '=' IDENTIFIER
;

check: '<'
	|'>'
;




%%
void yyerror(char *err) {
	fprintf(stderr, "%s\n",err);
}

int main(void) {
    yyparse();
    return 1;
}