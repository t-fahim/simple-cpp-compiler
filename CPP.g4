grammar CPP;

start : program EOF ;

program : unit* ;

unit
    : var_declaration
    | func_definition
    ;

func_definition
    : type_specifier ID LPAREN parameter_list RPAREN compound_statement
    | type_specifier ID LPAREN RPAREN compound_statement
    ;

parameter_list
    : parameter (COMMA parameter)*
    ;

parameter
    : type_specifier ID
    | type_specifier
    ;

compound_statement
    : LCURL statements RCURL
    | LCURL RCURL
    ;

var_declaration
    : type_specifier declaration_list SEMICOLON
    ;

type_specifier
    : INT
    | FLOAT
    | VOID
    ;

declaration_list
    : declaration (COMMA declaration)*
    ;

declaration
    : ID
    | ID LTHIRD CONST_INT RTHIRD
    ;

statements
    : statement*
    ;

statement
    : var_declaration
    | expression_statement
    | compound_statement
    | IF LPAREN expression RPAREN statement (ELSE statement)?
    | WHILE LPAREN expression RPAREN statement
    | FOR LPAREN expression_statement expression_statement expression RPAREN statement
    | PRINTLN LPAREN ID RPAREN SEMICOLON
    | RETURN expression SEMICOLON
    ;

expression_statement
    : expression? SEMICOLON
    ;

expression
    : variable ASSIGNOP expression
    | logic_expression
    ;

logic_expression
    : rel_expression (LOGICOP rel_expression)*
    ;

rel_expression
    : simple_expression (RELOP simple_expression)?
    ;

simple_expression
    : term (ADDOP term)*
    ;

term
    : unary_expression (MULOP unary_expression)*
    ;

unary_expression
    : ADDOP unary_expression
    | NOT unary_expression
    | factor
    ;

factor
    : variable
    | CONST_INT
    | CONST_FLOAT
    | LPAREN expression RPAREN
    | ID LPAREN argument_list RPAREN
    | variable INCOP
    | variable DECOP
    ;

variable
    : ID
    | ID LTHIRD expression RTHIRD
    ;

argument_list
    : arguments?
    ;

arguments
    : expression (COMMA expression)*
    ;


// --------------------
// LEXER RULES
// --------------------

IF      : 'if';
ELSE    : 'else';
FOR     : 'for';
WHILE   : 'while';
DO      : 'do';
INT     : 'int';
FLOAT   : 'float';
VOID    : 'void';
RETURN  : 'return';
PRINTLN : 'println';

ADDOP   : '+' | '-';
MULOP   : '*' | '/' | '%';
RELOP   : '==' | '!=' | '<' | '>' | '<=' | '>=';
LOGICOP : '&&' | '||';
ASSIGNOP: '=';
NOT     : '!';
INCOP   : '++';
DECOP   : '--';

LPAREN  : '(';
RPAREN  : ')';
LCURL   : '{';
RCURL   : '}';
LTHIRD  : '[';
RTHIRD  : ']';
COMMA   : ',';
SEMICOLON: ';';

ID      : [a-zA-Z_][a-zA-Z0-9_]*;
CONST_INT : [0-9]+;
CONST_FLOAT : [0-9]+ '.' [0-9]+;

WS : [ \t\r\n]+ -> skip;