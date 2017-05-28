#include <stdio.h>
#include <stdlib.h>


/*******************************************************
 *  short is 16-bit two's complement integer on many   *
 *  machines (but not all).  In COS 217, you would     *
 *  not want such unportable code, but we'll do it     *
 *  here for convenience and simplicity                *
 *******************************************************/
//short int R[16] = {0};         // registers
int R[16] = {0};         // registers
//short int mem[256] = {0};      // main memory
int mem[256] = {0};      // main memory

/*******************************************************
 *  unsigned char is usually an 8-bit integer          *
 *  same portability warning as above                  *
 *******************************************************/
unsigned char pc = 0X10;      // program counter


/*******************************************************
 *  print contents of pc and 16 registers              *
 *******************************************************/
void dumpreg(void) {
   int i;
   printf("pc: %02X\n", pc);
   printf(" R: ");
   for (i = 0; i < 16; i++)
      printf("%04hX ", R[i]);
   printf("\n");
}

/*******************************************************
 *  print contents of memory                           *
 *******************************************************/
void dumpmem(void) {
   int i, j;
   for (i = 0; i < 16; i++) {
      printf(" %hX: ", i);

      for (j = 0; j < 16; j++)
         printf("%04hX ", mem[16*i+j]);
      printf("\n");
   }
   printf("\n");
}

/*******************************************************
 *  print contents of memory                           *
 *******************************************************/
void dump(void) {
   dumpreg();
   dumpmem();
}


/*******************************************************
 *  TOY simulator                                      *
 *******************************************************/
int main(int argc, char *argv[]) {
   unsigned short addr, inst;
   int op, d, s, t, c, 	res;
   FILE *toyfile;

   if (argc != 2) {
      printf("Usage: %s file.toy\n", argv[0]);
      exit(EXIT_FAILURE);
   }

   toyfile = fopen(argv[1], "r");    // open file for reading
   if (toyfile == NULL) {
      printf("Error opening toy file %s\n", argv[1]);
      exit(EXIT_FAILURE);
   }


  /*****************************************************
   *  Read in memory location and instruction.         *
   *  'hX' in scanf refers to short integer in hex     *
   *****************************************************/
   while ((res = fscanf(toyfile, "%2hX: %4hX", &addr, &inst)) != EOF) {
      if (res == 2)
         mem[addr] = inst;                  // put instruction in memory 
      while ((c = getc(toyfile)) != EOF)    // allow comments in TOY code 
         if ((c == '\n') || (c == '\r'))                     // (by ignoring rest of line)
            break;           
   }

   printf("Core dump before running.\n");
   printf("-------------------------\n");
   dump();


   printf("TOY console.\n");
   printf("-------------------------\n");


  /****************************************
   *  Fetch-execute cycle.                *
   ****************************************/
   do {

     // dumpreg();

     // Fetch and parse
     inst = mem[pc++];                    // fetch next instruction
     op   = (inst >> 12) &  15;           // get opcode (bits 12-15)
     d    = (inst >>  8) &  15;           // get dest   (bits  8-11)
     s    = (inst >>  4) &  15;           // get s      (bits  4- 7)
     t    = (inst >>  0) &  15;           // get t      (bits  0- 3)
     addr = (inst >>  0) & 255;           // get addr   (bits  0- 7)

     // stdin
     if ((addr == 255 && op == 8) || (R[t] == 255 && op == 10)) 
        scanf("%04X", &mem[255]);
//        scanf("%4hX", &mem[255]);

     // Execute
     switch (op) {
        case  0:                            break;    // halt
        case  1: R[d] = R[s] +  R[t];       break;    // add
        case  2: R[d] = R[s] -  R[t];       break;    // subtract
        case  3: R[d] = R[s] &  R[t];       break;    // bitwise and
        case  4: R[d] = R[s] ^  R[t];       break;    // bitwise xor
        case  5: R[d] = R[s] << R[t];       break;    // shift left
        case  6: R[d] = R[s] >> R[t];       break;    // shift right
        case  7: R[d] = addr;               break;    // load address
        case  8: R[d] = mem[addr];          break;    // load
        case  9: mem[addr] = R[d];          break;    // store
        case 10: R[d] = mem[R[t] & 255];    break;    // load indirect
        case 11: mem[R[t] & 255] = R[d];    break;    // store indirect
        case 12: if (R[d] == 0) pc = addr;  break;    // branch if zero
        case 13: if (R[d] > 0) pc = addr;   break;    // branch if positive
        case 14: pc = R[d];                 break;    // jump indirect
        case 15: R[d] = pc; pc = addr;      break;    // jump and link
     }

     // stdout
     if ((addr == 255 && op == 9) || (R[t] == 255 && op == 11))
        printf("%04hX\n", mem[255]);

     R[0] = 0;  // ensure register 0 is always 0

   } while (op != 0);

   printf("\n\n");
   printf("Core dump after running.\n");
   printf("------------------------\n");
   dump();
   fclose(toyfile);
   return 0;
}
