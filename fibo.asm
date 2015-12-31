//
// Filename: fibo.nac
// Purpose : N-address code (NAC) implementation for the iterative version of 
//           Fibonacci series computation.
// Author  : Nikolaos Kavvadias (C) 2009, 2010, 2011, 2012, 2013, 2014, 2015, 
//                                  2016
// Date    : 17-Sep-2009
// Revision: 0.2.0 (17/09/09)
//           Initial version.
// 
// at = X[1]
// n = X[2]
// x = X[3]
// f0 = X[4]
// f1 = X[5]
// res = X[6]
// k = X[7]
// f = X[8]
// outp = X[9]
16:
X[2] <- mem[255]
X[3] <- X[2] + X[0]
X[4] <- 0
X[5] <- 1
X[6] <- X[4] + X[0]
if (X[3] == 0) pc <- 35
22:
X[6] <- X[5] + X[0]
X[1] <- 1
X[1] <- X[3] - X[1]
if (X[1] == 0) pc <- 35
26:
X[7] <- 1
27:
X[1] <- 1
X[7] <- X[7] + X[1]
X[8] <- X[5] + X[4]
X[4] <- X[5] + X[0]
X[5] <- X[8] + X[0]
X[6] <- X[8] + X[0]
X[1] <- X[3] - X[7]
if (X[1] > 0) pc <- 27
35:
X[9] <- X[6] + X[0]
mem[255] <- X[9]
halt
