//
// Filename: popcount.nac
// Purpose : N-address code (NAC) implementation for the "ones' count" (also 
//           known as population count) algorithm.
// Author  : Nikolaos Kavvadias (C) 2009, 2010, 2011, 2012, 2013, 2014, 2015, 
//                                  2016
// Date    : 13-Aug-2009
// Revision: 0.1.0 (13/08/09)
//           Initial version.
// 
// at = X[1]
// inp = X[2]
// data = X[3]
// count = X[4]
// temp = X[5]
// outp = X[6]
16:
X[2] <- mem[255]
X[3] <- X[2] + X[0]
X[4] <- 0
if (X[0] == 0) pc <- 20
20:
X[1] <- 1
X[5] <- X[3] & X[1]
X[4] <- X[4] + X[5]
X[3] <- X[3] >> X[1]
X[1] <- X[3] - X[0]
if (X[1] > 0) pc <- 20
X[1] <- X[0] - X[3]
if (X[1] > 0) pc <- 20
28:
X[6] <- X[4] + X[0]
mem[255] <- X[6]
halt
