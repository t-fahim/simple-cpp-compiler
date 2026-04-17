%{
#include <bits/stdc++.h>
#include "symbol_info.h"

#define YYSTYPE symbol_info*

void yyerror(const char *s);
int yylex(void);

extern FILE *yyin;
ofstream outlog, taclog, asmlog;

int lines = 1;
int tCount = 0; // Temporary variable counter
int lCount = 0; // Label counter

// Helpers
string newTemp() { return "t" + to_string(tCount++); }
string newLabel() { return "L" + to_string(lCount++); }
%}

/* --- Token Definitions --- */
%token IF ELSE FOR WHILE DO INT FLOAT VOID CHAR DOUBLE RETURN SWITCH CASE DEFAULT BREAK CONTINUE GOTO PRINTLN
%token ASSIGNOP ADDOP MULOP RELOP LOGICOP INCOP DECOP NOT
%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON COLON
%token ID CONST_INT CONST_FLOAT

%%

/* --- High Level Structure --- */

start : program 
    { 
        outlog << "Parsing Complete." << endl; 
    } 
    ;

program : program unit 
    | unit 
    ;

unit : var_declaration 
    | func_definition 
    ;

/* --- Function Definitions --- */

func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement 
    { 
        $$ = new symbol_info("func", "f"); 
    }
    | type_specifier ID LPAREN RPAREN compound_statement 
    { 
        $$ = new symbol_info("func", "f"); 
    } 
    ;

parameter_list : parameter_list COMMA type_specifier ID 
    | type_specifier ID 
    | type_specifier 
    ;

compound_statement : LCURL statements RCURL 
    { 
        $$ = $2; 
    } 
    | LCURL RCURL 
    { 
        $$ = new symbol_info("{}", "cs"); 
    } 
    ;

/* --- Variable Declarations --- */

var_declaration : type_specifier declaration_list SEMICOLON 
    { 
        $$ = new symbol_info("var", "v"); 
    } 
    ;

type_specifier : INT | FLOAT | VOID ;

declaration_list : ID 
    | ID LTHIRD CONST_INT RTHIRD 
    | declaration_list COMMA ID 
    ;

/* --- Statements & Control Flow --- */

statements : statement 
    { 
        $$ = $1; 
    } 
    | statements statement 
    { 
        $$ = new symbol_info($1->getname() + "\n" + $2->getname(), "ss"); 
    } 
    ;

statement : var_declaration 
    | expression_statement 
    | compound_statement
    | IF LPAREN expression RPAREN statement 
    {
        string l1 = newLabel(); 
        taclog << "if !" << $3->result << " goto " << l1 << endl;
        taclog << l1 << ":" << endl;
        $$ = new symbol_info("if", "st");
    }
    | IF LPAREN expression RPAREN statement ELSE statement 
    {
        string l1 = newLabel(), l2 = newLabel();
        taclog << "if !" << $3->result << " goto " << l1 << endl;
        taclog << "goto " << l2 << endl;
        taclog << l1 << ":" << endl;
        taclog << l2 << ":" << endl;
        $$ = new symbol_info("ifelse", "st");
    }
    | WHILE LPAREN expression RPAREN statement 
    {
        string l1 = newLabel(), l2 = newLabel();
        taclog << l1 << ":" << endl;
        taclog << "if !" << $3->result << " goto " << l2 << endl;
        taclog << "goto " << l1 << endl;
        taclog << l2 << ":" << endl;
        $$ = new symbol_info("while", "st");
    }
    | PRINTLN LPAREN ID RPAREN SEMICOLON 
    { 
        taclog << "print " << $3->getname() << endl; 
        $$ = new symbol_info("prnt", "st"); 
    }
    | RETURN expression SEMICOLON 
    { 
        taclog << "return " << $2->result << endl; 
        $$ = new symbol_info("ret", "st"); 
    } 
    | FOR LPAREN expression_statement expression_statement expression RPAREN statement
    {
        string startLabel = newLabel();
        string endLabel = newLabel();
        
        // Note: $3 and $4 are expression_statements, so they already contain ';'
        taclog << startLabel << ":" << endl;
        taclog << "if !" << $4->result << " goto " << endLabel << endl;
        
        // $7 is the body, $5 is the increment expression
        taclog << "goto " << startLabel << endl;
        taclog << endLabel << ":" << endl;
        
        $$ = new symbol_info("for", "st");
    }
    ;

expression_statement : SEMICOLON | expression SEMICOLON ;

/* --- Expressions & Assignments --- */

variable : ID 
    { 
        $$ = new symbol_info($1->getname(), "v"); 
        $$->result = $1->getname(); 
    }
    | ID LTHIRD expression RTHIRD 
    { 
        string t = newTemp(); 
        taclog << t << "=" << $1->getname() << "[" << $3->result << "]" << endl; 
        $$ = new symbol_info("arr", "v"); 
        $$->result = t; 
    } 
    ;

expression : logic_expression 
    { 
        $$ = $1; 
    }
    | variable ASSIGNOP logic_expression 
    { 
        taclog << $1->result << "=" << $3->result << endl; 
        asmlog << "MOV R0, " << $3->result << endl;
        asmlog << "MOV " << $1->result << ", R0" << endl; 
        $$ = $1; 
    } 
    ;

logic_expression : rel_expression 
    | rel_expression LOGICOP rel_expression 
    { 
        string t = newTemp(); 
        taclog << t << "=" << $1->result << $2->getname() << $3->result << endl; 
        $$ = new symbol_info("lo", "e"); 
        $$->result = t; 
    } 
    ;

rel_expression : simple_expression 
    | simple_expression RELOP simple_expression 
    { 
        string t = newTemp(); 
        taclog << t << "=" << $1->result << $2->getname() << $3->result << endl; 
        $$ = new symbol_info("re", "e"); 
        $$->result = t; 
    } 
    ;

simple_expression : term 
    | simple_expression ADDOP term 
    { 
        string t = newTemp(); 
        taclog << t << "=" << $1->result << $2->getname() << $3->result << endl; 
        asmlog << "MOV R0, " << $1->result << endl;
        asmlog << ( ($2->getname()=="+") ? "ADD" : "SUB" ) << " R0, " << $3->result << endl;
        asmlog << "MOV " << t << ", R0" << endl;
        $$ = new symbol_info("se", "e"); 
        $$->result = t; 
    } 
    ;

term : unary_expression 
    | term MULOP unary_expression 
    { 
        string t = newTemp(); 
        taclog << t << "=" << $1->result << $2->getname() << $3->result << endl;
        asmlog << "MOV R0, " << $1->result << endl;
        asmlog << ( ($2->getname()=="*") ? "MUL" : "DIV" ) << " R0, " << $3->result << endl;
        asmlog << "MOV " << t << ", R0" << endl;
        $$ = new symbol_info("tm", "e"); 
        $$->result = t; 
    } 
    ;

/* --- Unary Operators & Factors --- */

unary_expression : factor 
    | ADDOP unary_expression 
    { 
        string t = newTemp(); 
        taclog << t << "=" << $1->getname() << $2->result << endl; 
        $$ = new symbol_info("u", "u"); 
        $$->result = t; 
    }
    | NOT unary_expression 
    { 
        string t = newTemp(); 
        taclog << t << "=!" << $2->result << endl; 
        $$ = new symbol_info("u", "u"); 
        $$->result = t; 
    } 
    ;

factor : variable 
    | CONST_INT 
    { 
        $$ = new symbol_info($1->getname(), "f"); 
        $$->result = $1->getname(); 
    }
    | CONST_FLOAT 
    { 
        $$ = new symbol_info($1->getname(), "f"); 
        $$->result = $1->getname(); 
    }
    | LPAREN expression RPAREN 
    { 
        $$ = $2; 
    }
    | ID LPAREN argument_list RPAREN 
    { 
        string t = newTemp(); 
        taclog << t << "= CALL " << $1->getname() << ", " << $3->result << endl; 
        asmlog << "CALL " << $1->getname() << endl;
        asmlog << "MOV " << t << ", R0" << endl;
        $$ = new symbol_info("call", "f"); 
        $$->result = t; 
    }
    | variable INCOP 
    { 
        taclog << $1->result << "=" << $1->result << "+1" << endl; 
        $$ = $1; 
    }
    | variable DECOP 
    { 
        taclog << $1->result << "=" << $1->result << "-1" << endl; 
        $$ = $1; 
    } 
    ;

/* --- Arguments --- */

argument_list : arguments 
    { 
        $$ = $1; 
    } 
    | /* empty */
    { 
        $$ = new symbol_info("", ""); 
        $$->result = ""; 
    } 
    ;

arguments : logic_expression 
    { 
        $$ = $1; 
    } 
    | arguments COMMA logic_expression 
    { 
        $$ = new symbol_info("args", "a"); 
        $$->result = $1->result + "," + $3->result; 
    } 
    ;

%%

/* --- C++ Code Section --- */

void yyerror(const char *s) {
    outlog << "Error: " << s << " at line " << lines << endl;
    cout << "\nSyntax Error at line " << lines << ": " << s << endl<<endl;

}

int main(int argc, char *argv[]) {
    if(argc < 2) {
        cout << "Please provide input file." << endl;
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if(!yyin) {
        cout << "Could not open input file." << endl;
        return 1;
    }

    outlog.open("my_log.txt"); 
    taclog.open("tac.txt"); 
    asmlog.open("assembly.txt");

    yyparse();

    outlog.close(); 
    taclog.close(); 
    asmlog.close(); 
    fclose(yyin);

    return 0;
}


