/* Filename    : main.c */
/* Version     : 0.0.1 */
/* Date        : 06-Dec-2010 */                 
/* Description : TOY assembler main routine */     
/* Author      : Nikolaos Kavvadias <nikolaos.kavvadias@gmail.com> */
 
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "toy.tab.h"

extern FILE *yyin;

int main(int argc, char *argv[])
{
  char *infilename = NULL;

  if (argc < 2) 
  {
    fprintf(stderr, "Usage: toyasm <input file> > <output file>\n");
    exit(1);
  }
  
  /* Get input file name (without asm extension) */
  infilename = malloc((strlen(argv[1])+1) * sizeof(char));
  strcpy(infilename, argv[1]);
  
  /* infile is passed as input to the yacc-generated parser */
  yyin = fopen(infilename, "r");

  /* Check if input file exists */	
  if (yyin == NULL) 
  {
    fprintf(stderr, "Can't open file '%s'.\n", infilename);
    exit(1);
  }
  
  /* Instantiate yyparse() routine to parse the input file */
  /* In this pass (pass 1), only the symbol entries are extracted */
  yyparse();
  
  /* Close input file (assembly code) */
  fclose(yyin);

  /* Free memory */
  free(infilename);
  
  return 0;
}
