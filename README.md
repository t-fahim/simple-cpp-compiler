# C++ Compiler (From Scratch)

A simple compiler built from scratch, featuring core compilation phases including **lexical analysis**, **parsing**, and **basic code generation**. This project uses **Flex** and **Bison**.


## 📌 Features

- Lexical Analysis using Flex  
- Syntax Parsing using Bison  
- Three Address Code (TAC) Generation  
- Basic Assembly Code Generation  
- Output logs saved to files  

## Example Output Files
 
### my_log.txt (Lexical Output)
```
Line no 1 : Token <INT> Lexeme int found
Line no 1 : Token <ID> Lexeme main found
Line no 1 : Token <LPAREN> Lexeme ( found
Line no 1 : Token <RPAREN> Lexeme ) found
Line no 1 : Token <LCURL> Lexeme { found
Line no 2 : Token <INT> Lexeme int found
...
```
 
### tac.txt (Three Address Code)
```
t1 = 5 + 3
t2 = t1 * 2
result = t2
```
 
### assembly.txt (Assembly Output)
```
MOV R0, 10
MOV limit, R0
MOV R0, 0
MOV result, R0
MOV R0, 1.0
MOV x, R0
MOV R0, 2.5
```

## 📂 Project Structure
```
project-root/
├── input.txt                # Input source code file
├── my_log.txt               # Lexical analysis output
├── tac.txt                  # Three Address Code output
├── assembly.txt             # Generated assembly code
├── Makefile                 # Build automation file
├── lex_analyzer.l           # Flex file(s) - Lexical analyzer specifications
├── syntax_analyzer.y        # Bison file(s) - Parser grammar specifications
└── symbol_info.h            # Supporting C++ source/header files
```

## 🛠️ Technologies Used
 
* C++
* Flex
* Bison
* Makefile
## Building the Project
 
### Using Makefile
 
```bash
# Compile the project
make
 
# Clean build artifacts
make clean
```
## Component Details
 
### Lexical Analyzer (`*.l`)
- **Tool:** Flex (Fast Lexical Analyzer Generator)
- **Output:** `my_log.txt`
- **Responsibility:** 
  - Tokenizes input source code
  - Recognizes keywords, identifiers, operators, literals
  - Tracks line and column numbers
  - Filters whitespace and comments (typically)
### Parser (`*.y`)
- **Tool:** Bison (YACC-compatible parser generator)
- **Input:** Token stream from lexer
- **Responsibility:**
  - Validates syntactic structure
  - Builds parse tree or AST
  - Detects syntax errors
  - Interfaces with semantic analysis
### Three Address Code Generator
- **Output:** `tac.txt`
- **Purpose:** Intermediate representation
- **Instruction Format:** `result = operand1 op operand2`
- **Benefits:**
  - Machine-independent
  - Optimizable
  - Suitable for multiple target architectures
### Assembly Generator
- **Output:** `assembly.txt`
- **Purpose:** Target machine code (pseudo-assembly or real ISA)
- **Typical Outputs:**
  - intel 8086 assemly language

## 📄 Notes
 
* Input must be provided in `input.txt`
* Ensure Flex and Bison are installed before running

**Last Updated:** April 18, 2026