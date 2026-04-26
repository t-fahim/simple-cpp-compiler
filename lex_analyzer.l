%option noyywrap

%{

#include <bits/stdc++.h>
#include "symbol_info.h"
#define YYSTYPE symbol_info*
#include "y.tab.h"
extern YYSTYPE yylval;
using namespace std;
void yyerror(char *);
string loglist;
extern int lines;
extern ofstream outlog;

%}


delim [ \t\f\v\r]

/* whilespace and newline */

ws {delim}+
newline \n

letter[A-Za-z]
digit [0-9]
underscore [_]
sign [+-]

/* id, float and integers */
id ({letter}|{underscore})({letter}|{digit}|{underscore})*
float ({digit}+\.{digit}*|\.{digit}+)([eE]{sign}?{digit}+)?
integers {digit}+

%%


{ws} { /* ignore */ }
{newline} { lines++; }
"/*"([^*]|\*+[^/*])*\*+"/" { /* ignore multi-line comments */ }
"//".* { /* ignore single-line comments */ }

"if" {
    loglist = "Line no " + to_string(lines)+ " : Token <IF> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return IF;
}

"else" {
    loglist = "Line no " + to_string(lines) + " : Token <ELSE> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return ELSE;
}

"while" {
    loglist = "Line no " + to_string(lines)+ " : Token <WHILE> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return WHILE;
}

"for" {
    loglist = "Line no " + to_string(lines)+ " : Token <FOR> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return FOR;
}

"int" {
    loglist = "Line no " + to_string(lines)+ " : Token <INT> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return INT; 
}

"float" {
    loglist = "Line no " + to_string(lines)+ " : Token <FLOAT> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return FLOAT;
}

"void" {
    loglist = "Line no " + to_string(lines)+ " : Token <VOID> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return VOID;
}

"return" {
    loglist = "Line no " + to_string(lines)+ " : Token <RETURN> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return RETURN;
}

"do" {
    loglist = "Line no " + to_string(lines) + " : Token <DO> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return DO;
}

"break" {
    loglist = "Line no " + to_string(lines) + " : Token <BREAK> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return BREAK;
}

"char" {
    loglist = "Line no " + to_string(lines) + " : Token <CHAR> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return CHAR;
}

"double" {
    loglist = "Line no " + to_string(lines) + " : Token <DOUBLE> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return DOUBLE;
}

"switch" {
    loglist = "Line no " + to_string(lines) + " : Token <SWITCH> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return SWITCH;
}

"case" {
    loglist = "Line no " + to_string(lines) + " : Token <CASE> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return CASE;
}

"default" {
    loglist = "Line no " + to_string(lines) + " : Token <DEFAULT> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return DEFAULT;
}

"continue" {
    loglist = "Line no " + to_string(lines) + " : Token <CONTINUE> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return CONTINUE;
}

"goto" {
    loglist = "Line no " + to_string(lines) + " : Token <GOTO> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return GOTO;
}

"printf"|"println" {
    loglist = "Line no " + to_string(lines)+ " : Token <PRINTLN> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return PRINTLN;
}

{id} {
    symbol_info *s = new symbol_info((string)yytext,"ID");
    yylval = (YYSTYPE)s;
    loglist = "Line no " + to_string(lines)+ " : Token <ID> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return ID;
}

{float} {
    symbol_info *s = new symbol_info((string)yytext,"CONST_FLOAT");
    yylval = (YYSTYPE)s;
    loglist = "Line no " + to_string(lines)+ " : Token <CONST_FLOAT> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return CONST_FLOAT;
}

{integers} {
    symbol_info *s = new symbol_info((string)yytext,"CONST_INT");
    yylval = (YYSTYPE)s;
    loglist = "Line no " + to_string(lines)+ " : Token <CONST_INT> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return CONST_INT;
}

"++" {
    symbol_info *s = new symbol_info((string)yytext, "INCOP"); 
    yylval = (YYSTYPE)s;
    loglist = "Line no " + to_string(lines) + " : Token <INCOP> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return INCOP;
}

"--" {
    symbol_info *s = new symbol_info((string)yytext, "DECOP"); 
    yylval = (YYSTYPE)s;
    loglist = "Line no " + to_string(lines) + " : Token <DECOP> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return DECOP;
}

"+"|"-" {
    symbol_info *s = new symbol_info((string)yytext,"ADDOP");
    yylval = (YYSTYPE)s;
    loglist = "Line no " + to_string(lines)+ " : Token <ADDOP> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return ADDOP;
}

"*"|"/"|"%" {
    symbol_info *s = new symbol_info((string)yytext,"MULOP");
    yylval = (YYSTYPE)s;
    loglist = "Line no " + to_string(lines)+ " : Token <MULOP> Lexeme " + yytext + " found\n";
    outlog<<loglist;
    return MULOP;
}

"<"|">"|"=="|"<="|">="|"!=" {
    symbol_info *s = new symbol_info((string)yytext, "RELOP");
    yylval = (YYSTYPE)s;
    loglist = "Line no " + to_string(lines) + " : Token <RELOP> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return RELOP;
}

"=" {
    yylval = (YYSTYPE)new symbol_info(yytext, "ASSIGNOP");
    loglist = "Line no " + to_string(lines) + " : Token <ASSIGNOP> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return ASSIGNOP;
}

"&&"|"||" {
    symbol_info *s = new symbol_info((string)yytext, "LOGICOP");
    yylval = (YYSTYPE)s;
    loglist = "Line no " + to_string(lines) + " : Token <LOGICOP> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return LOGICOP;
}

"!" {
    yylval = (YYSTYPE)new symbol_info(yytext, "NOT");
    loglist = "Line no " + to_string(lines) + " : Token <NOT> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return NOT;
}

"(" {
    loglist = "Line no " + to_string(lines) + " : Token <LPAREN> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return LPAREN;
}

")" {
    loglist = "Line no " + to_string(lines) + " : Token <RPAREN> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return RPAREN;
}

"{" {
    loglist = "Line no " + to_string(lines) + " : Token <LCURL> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return LCURL;
}

"}" {
    loglist = "Line no " + to_string(lines) + " : Token <RCURL> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return RCURL;
}

"[" {
    loglist = "Line no " + to_string(lines) + " : Token <LTHIRD> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return LTHIRD;
}

"]" {
    loglist = "Line no " + to_string(lines) + " : Token <RTHIRD> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return RTHIRD;
}

"," {
    loglist = "Line no " + to_string(lines) + " : Token <COMMA> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return COMMA;
}

":" {
    loglist = "Line no " + to_string(lines) + " : Token <COLON> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return COLON;
}

";" {
    loglist = "Line no " + to_string(lines) + " : Token <SEMICOLON> Lexeme " + yytext + " found\n";
    outlog << loglist;
    return SEMICOLON;
}



%%
