/*
 * Filename: fibo.c
 * Purpose : Iterative approach to computing the Fibonacci series up to the N-th 
 *           member, written in ANSI C.
 *           To compile the low-level C version use the following GCC options
 *             "-DTEST -DLOWLEVEL -O2".
 *           To compile the algorithmic version use
 *             "-DTEST -DALGORITHMIC -O2".
 * Author  : Nikolaos Kavvadias (C) 2009
 * Date    : 17-Sep-2009
 * Revision: 0.2.0 (17/09/09)
 *           Initial version.
 */ 

#include <stdio.h>

#define MAX_NUM  32


int fibo(int x)
{
  int f0, f1, f, k;
  
  f0 = 0;
  f1 = 1;
  
  if (x <= 0)
  {
    return (f0);
  }
  else if (x == 1)
  {
    return (f1);
  }
  else
  {
    for (k = 2; k <= x; k++)
    {
      f = f1 + f0;
      f0 = f1;
      f1 = f;
    }
  }
  
  return (f);
}

int main()
{
  int i;
  int result;

  for (i = 0; i <= MAX_NUM; i++)
  {
    result = fibo(i);
    printf("%d %d\n", i, result);
  }
  
  return 0;
}
