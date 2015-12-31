/*
 * Filename: popcount.c
 * Purpose : C implementation for the "ones' count" (also known as population
 *           count) algorithm. This algorithm computes the number of 1's present 
 *           in the given input word.
 *           To compile the low-level C version use the following GCC options
 *             "-DTEST -DLOWLEVEL -O2".
 *           To compile the algorithmic version use
 *             "-DTEST -DALGORITHMIC -O2".
 * Author  : Nikolaos Kavvadias (C) 2009, 2010, 2011, 2012, 2013, 2014, 2015, 
 *                                  2016
 * Date    : 30-Aug-2009
 * Revision: 0.1.0 (13/08/09)
 *           Initial version.
 *           0.1.1 (30/08/09)
 *           Added the ALGORITHMIC version of the population count algorithm.
 */ 

#include <stdio.h>

void popcount(int inp, int *outp)
{
  int data, count, temp;

  data = inp;
  count = 0;
  
  while (data != 0)
  {
    count = count + (data & 0x1);
    data = data >> 0x1;
  }
  
  *outp = count;
}

int main()
{
  int i;
  int result;

  for (i = 0; i <= 255; i++)
  {
    popcount(i, &result);
    printf("%08x %08x\n", i, result);
  }
  
  return 0;
}
