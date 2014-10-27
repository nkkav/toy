/* toy.y: TOY assembly parser by Nikolaos Kavvadias (C). */
%{                          
  #include <stdio.h>    
  #include <stdlib.h>
  #include <string.h>
   
  #define YYSTYPE unsigned int
  
  extern char *yytext; 
  extern char regnum; 
  extern int immediate; 
  int decode(char);
  unsigned int instr_encoding = 0;  /* instruction word. */ 
  int loc = 0x10;
  int opval = 0;
%} 
 
%token T_SEMI T_ASSIGN T_COLON T_LBRACKET T_RBRACKET T_LPAREN T_RPAREN
%token T_ADD_OP T_SUB_OP T_AND_OP T_XOR_OP T_SHL_OP T_SHR_OP
%token T_EQUAL T_GREATER T_IMM T_HEX
%token T_HALT T_REG T_XREG T_MEM T_PC T_IF

%start program_body 
%% 
 
program_body: stmt
    | program_body stmt
    ; 	 
 
stmt: T_IMM T_COLON
    | instr 
    {
      loc++;
      instr_encoding = 0;
      opval = 0;
    }
    ;
 

imm: T_IMM 
    { 
      $$ = immediate; 
    } 
	; 

hex: T_HEX
    { 
      $$ = decode(regnum); 
    } 
	; 

reg: T_REG
    | T_XREG;
	; 

instr: arith_instruction 
    | lda_instruction
	| load_instruction
	| store_instruction
	| loadi_instruction
	| storei_instruction
	| bzero_instruction
	| bpos_instruction
	| jumpreg_instruction
	| jal_instruction
	| halt_instruction
    ; 
        
op: T_ADD_OP 
    {
      opval = 0x1;
    }    
    | T_SUB_OP
    {
      opval = 0x2;
    }    
	| T_AND_OP
    {
      opval = 0x3;
    }    
	| T_XOR_OP
    {
      opval = 0x4;
    }    
	| T_SHL_OP
    {
      opval = 0x5;
    }    
	| T_SHR_OP
    {
      opval = 0x6;
    }    
    ; 

lda_instruction: reg hex T_ASSIGN imm
    {
      opval = 0x7;
      instr_encoding = (opval << 12) | ($2 << 8) | $4;
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 

arith_instruction: reg hex T_ASSIGN reg hex op reg hex 
    {
      instr_encoding = (opval << 12) | ($2 << 8) | ($5 << 4) | $8;
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 

load_instruction:  reg hex T_ASSIGN T_MEM T_LBRACKET imm T_RBRACKET 
    {
      opval = 0x8;
      instr_encoding = (opval << 12) | ($2 << 8) | $6;
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 

store_instruction: T_MEM T_LBRACKET imm T_RBRACKET T_ASSIGN reg hex
    {
      opval = 0x9;
      instr_encoding = (opval << 12) | ($7 << 8) | $3;
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 

loadi_instruction: reg hex T_ASSIGN T_MEM T_LBRACKET reg hex T_RBRACKET 
    {
      opval = 0xA;
      instr_encoding = (opval << 12) | ($2 << 8) | $7;
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 

storei_instruction: T_MEM T_LBRACKET reg hex T_RBRACKET T_ASSIGN reg hex 
    {
      opval = 0xB;
      instr_encoding = (opval << 12) | ($8 << 8) | $4;
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 

bzero_instruction: T_IF T_LPAREN reg hex T_EQUAL imm T_RPAREN T_PC T_ASSIGN imm
    {
      opval = 0xC;
      instr_encoding = (opval << 12) | ($4 << 8) | $10;
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 

bpos_instruction: T_IF T_LPAREN reg hex T_GREATER imm T_RPAREN T_PC T_ASSIGN imm
    {
      opval = 0xD;
      instr_encoding = (opval << 12) | ($4 << 8) | $10;
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 

jumpreg_instruction: T_PC T_ASSIGN reg hex
    {
      opval = 0xE;
      instr_encoding = (opval << 12) | ($4 << 8);
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 

jal_instruction: reg hex T_ASSIGN T_PC T_SEMI T_PC T_ASSIGN imm
    {
      opval = 0xF;
      instr_encoding = (opval << 12) | ($2 << 8) | immediate;
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 

halt_instruction: T_HALT
    {
      opval = 0x0;
      instr_encoding = 0x0000;
      printf("%02X:%04X\n", loc, instr_encoding);
    }
  ; 
	 
%% 
 
#include <stdio.h> 
#include <string.h>    /* For strcmp, strlen */ 
 
extern int column; 
 
/* Global variables for YACC interpreter */ 
extern FILE *yyin; 
 
int decode(char c) 
{ 
  char t = tolower(c);
  int val;
  switch (t)
  {
    case '0': val =  0; break;
    case '1': val =  1; break;
    case '2': val =  2; break;
    case '3': val =  3; break;
    case '4': val =  4; break;
    case '5': val =  5; break;
    case '6': val =  6; break;
    case '7': val =  7; break;
    case '8': val =  8; break;
    case '9': val =  9; break;
    case 'a': val = 10; break;
    case 'b': val = 11; break;
    case 'c': val = 12; break;
    case 'd': val = 13; break;
    case 'e': val = 14; break;
    case 'f': val = 15; break;
    default: fprintf(stderr,"Unknown character (%02x).\n", t); exit (-1);
  }
  return (val);
} 
 
int yyerror(char *s) 
{ 
  fflush(stdout); 
  printf("\n%*s\n%*s\n", column, "^", column, s); 
  return 0;
}
