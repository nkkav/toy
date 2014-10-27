/* toy.l : lexer for TOY assembly language. 
 * Author: Nikolaos Kavvadias (C). 
 */ 
%{  
#include <stdio.h> 
#include <ctype.h> 
#include <string.h> 
#include <stdlib.h> 
#include "toy.tab.h" 
 
int immediate; 
char regnum;
void count(); 
 
%} 

ws	     [ \t\n\f\r]
hexdigit [0-9a-fA-F]
digit	 [0-9] 
A	[aA] 
B	[bB] 
C	[cC] 
D	[dD] 
E	[eE] 
F	[fF] 
G	[gG] 
H	[hH] 
I	[iI] 
J	[jJ] 
K	[kK] 
L	[lL] 
M	[mM] 
N	[nN] 
O	[oO] 
P	[pP] 
Q	[qQ] 
R	[rR] 
S	[sS] 
T	[tT] 
U	[uU] 
V	[vV] 
W	[wW] 
X	[xX] 
Y	[yY] 
Z	[zZ] 
 
%%            
"//".*        { count(); }
{ws}          ;
"["{hexdigit}"]" { count(); 
                regnum = yytext[1]; 
                return(T_HEX); }
"["           { count(); 
                return(T_LBRACKET); }
"]"           { count(); 
                return(T_RBRACKET); }
"("           { count(); 
                return(T_LPAREN); }
")"           { count(); 
                return(T_RPAREN); }
":"           { count();
                return(T_COLON); }
";"           { count();
                return(T_SEMI); }
"<-"          { count();
		        return(T_ASSIGN); }  
"+"           { count();
		        return(T_ADD_OP); }  
"-"           { count();
		        return(T_SUB_OP); }  
"&"           { count();
		        return(T_AND_OP); }  
"^"           { count();
		        return(T_XOR_OP); }  
"<<"          { count();
		        return(T_SHL_OP); }  
">>"          { count();
		        return(T_SHR_OP); }  
"=="          { count();
		        return(T_EQUAL); }  
">"           { count();
		        return(T_GREATER); }  
{R}           { count();
                return(T_REG); }
{X}           { count();
                return(T_XREG); }
{H}{A}{L}{T}  { count();
                return(T_HALT); }
{M}{E}{M}     { count();
		        return(T_MEM); } 
{P}{C}        { count();
		        return(T_PC); } 
{I}{F}        { count();
		        return(T_IF); } 
{digit}+      { count(); 
                immediate = atoi(yytext); 
                return(T_IMM); }
.             { fprintf(stderr, "Error: Unacceptable input character (0x%x).\n", 
                yytext[0]);
                exit(1); } 
%% 
 
int column = 0;

int yywrap()
{
  return(1);
}       
 
void count() 
{ 
	int i; 
 
	for (i = 0; yytext[i] != '\0'; i++) 
		if (yytext[i] == '\n') 
			column = 0; 
		else if (yytext[i] == '\t') 
			column += 8 - (column % 8); 
		else 
			column++; 
} 
