// div_mod.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <cmath>

// Division and Modulus for Computer Scientists.pdf

// The Euclidean Definition of the Functions div and mod.pdf

// https://julesjacobs.com/2023/09/23/on-div-and-mod.html

// Try 5 = q * 2 + r
// E - definition: q = 2, r = 1
// F - definition: q = 2, r = 1
// T - definition: q = 2, r = 1
// C - definition: q = 3, r = -1

// Try - 5 = q * 2 + r
// E - definition: q = -3, r = 1
// F - definition: q = -3, r = 1
// T - definition: q = -2, r = -1
// C - definition: q = -2, r = -1

// Try 5 = q*-2 + r
// E - definition: q = -2, r = 1
// F - definition: q = -3, r = -1
// T - definition: q = -2, r = 1
// C - definition: q = -2, r = 1

// Try - 5 = q*-2 + r
// E - definition: q = 3, r = 1
// F - definition: q = 2, r = -1
// T - definition: q = 2, r = -1
// C - definition: q = 3, r = 1

// 一些经验：
// 越是底层的语言（C, Java, Go, Rust），提供的 div mod 通常是基于 T-definition
// 上层语言（比如：Python, Racket），采用 F-definition
// 更上层的语言，特别是新语言（比如：Koka），采用 E-definition

/* Euclidean division */
long divE(long D, long d)
{
	long q = D / d;
	long r = D%d;
	if (r < 0) {
		if (d > 0) q = q - 1;
		else q = q + 1;
	}
	return q;
}
long modE(long D, long d)
{
	long r = D%d;
	if (r < 0) {
		if (d > 0) r = r + d;
		else r = r - d;
	}
	return r;
}

/* Floored division */
long divF(long D, long d)
{
	long q = D / d;
	long r = D%d;
	if ((r > 0 && d < 0) || (r < 0 && d > 0)) q = q - 1;
	return q;
}
long modF(long D, long d)
{
	long r = D%d;
	if ((r > 0 && d < 0) || (r < 0 && d > 0)) r = r + d;
	return r;
}


/* Trunc division */
long divT(long D, long d)
{
	return D / d;
}
long modT(long D, long d)
{
	return D%d;
}


/* Ceiling division */

//(define(divC D d)
//(ceiling(/ D d)))

//(define(modC D d)
//(-D(*d(divC D d))))


void test_0()
{
	long q;
	long r;

		q = divE(-5, 3);
		r = modE(-5, 3);
		printf("E-definition: q=%d, r=%d\n", q, r);
	//	E - definition: q = -2, r = 1
	
		q = divF(-5, 3);
		r = modF(-5, 3);
		printf("F-definition: q=%d, r=%d\n", q, r);
	//	F - definition : q = -2, r = 1
}

void test_1()
{
	long q;
	long r;

//	q = divE(-16, 5);
//	r = modE(-16, 5);
//	printf("E-definition: q=%d, r=%d\n", q, r);
//
//	q = divF(-16, 5);
//	r = modF(-16, 5);
//	printf("F-definition: q=%d, r=%d\n", q, r);
//
//
//	q = divE(16, -5);
//	r = modE(16, -5);
//	printf("E-definition: q=%d, r=%d\n", q, r);
//
//	q = divF(16, -5);
//	r = modF(16, -5);
//	printf("F-definition: q=%d, r=%d\n", q, r);
//
//
//	q = divE(-16, 5);
//	r = modE(-16, 5);
//	printf("E-definition: q=%d, r=%d\n", q, r);
//
//	q = divT(-16, 5);
//	r = modT(-16, 5);
//	printf("T-definition: q=%d, r=%d\n", q, r);


//	E-def, when d < 0
//	[0] [1] [2] [3] [4]

//	F-def, when d < 0
//	[0] [-4][-3][-2][-1]
//    0 + M
//   -4 + M
//   -3 + M
//	 -2 + M 
//	 -1 + M

//	 16 =  1  + -3 * -5
//	 16 = -4 + -4 * -5
//
//	 17 =  2  + -3 * -5
//	 17 = -3  + -4 * -5
//
//	 18 =  3  + -3 * -5
//	 18 = -2  + -4 * -5
//
//	 19 =  4  + -3 * -5
//	 19 = -1  + -4 * -5


//	-16 =  4 + 4 * -5
//	-16 = -1 + 3 * -5 
//
//	-17 =  3 + 4 * -5
//	-17 = -2 + 3 * -5 
//
//	-18 =  2 + 4 * -5
//	-18 = -3 + 3 * -5 
//
//	-19 =  1 + 4 * -5
//	-19 = -4 + 3 * -5 


	printf("Try 16 = q*5 + r\n");

	q = divE(16, 5);
	r = modE(16, 5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(16, 5);
	r = modF(16, 5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try -16 = q*5 + r\n");

	q = divE(-16, 5);
	r = modE(-16, 5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(-16, 5);
	r = modF(-16, 5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try 16 = q*-5 + r\n");

	q = divE(16, -5);
	r = modE(16, -5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(16, -5);
	r = modF(16, -5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try -16 = q*-5 + r\n");

	q = divE(-16, -5);
	r = modE(-16, -5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(-16, -5);
	r = modF(-16, -5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try 17 = q*5 + r\n");

	q = divE(17, 5);
	r = modE(17, 5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(17, 5);
	r = modF(17, 5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try -17 = q*5 + r\n");

	q = divE(-17, 5);
	r = modE(-17, 5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(-17, 5);
	r = modF(-17, 5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try 17 = q*-5 + r\n");

	q = divE(17, -5);
	r = modE(17, -5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(17, -5);
	r = modF(17, -5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try -17 = q*-5 + r\n");

	q = divE(-17, -5);
	r = modE(-17, -5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(-17, -5);
	r = modF(-17, -5);
	printf("F-definition: q=%d, r=%d\n", q, r);


	printf("Try 18 = q*5 + r\n");

	q = divE(18, 5);
	r = modE(18, 5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(18, 5);
	r = modF(18, 5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try -18 = q*5 + r\n");

	q = divE(-18, 5);
	r = modE(-18, 5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(-18, 5);
	r = modF(-18, 5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try 18 = q*-5 + r\n");

	q = divE(18, -5);
	r = modE(18, -5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(18, -5);
	r = modF(18, -5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try -18 = q*-5 + r\n");

	q = divE(-18, -5);
	r = modE(-18, -5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(-18, -5);
	r = modF(-18, -5);
	printf("F-definition: q=%d, r=%d\n", q, r);


	printf("Try 19 = q*5 + r\n");

	q = divE(19, 5);
	r = modE(19, 5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(19, 5);
	r = modF(19, 5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try -19 = q*5 + r\n");

	q = divE(-19, 5);
	r = modE(-19, 5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(-19, 5);
	r = modF(-19, 5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try 19 = q*-5 + r\n");

	q = divE(19, -5);
	r = modE(19, -5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(19, -5);
	r = modF(19, -5);
	printf("F-definition: q=%d, r=%d\n", q, r);

	printf("Try -19 = q*-5 + r\n");

	q = divE(-19, -5);
	r = modE(-19, -5);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(-19, -5);
	r = modF(-19, -5);
	printf("F-definition: q=%d, r=%d\n", q, r);


}

void test_2()
{
	long q;
	long r;

	// Try 5 = q*2 + r
	printf("Try 5 = q*2 + r\n");

	q = divE(5, 2);
	r = modE(5, 2);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(5, 2);
	r = modF(5, 2);
	printf("F-definition: q=%d, r=%d\n", q, r);

	q = divT(5, 2);
	r = modT(5, 2);
	printf("T-definition: q=%d, r=%d\n", q, r);

	// Try -5 = q*2 + r
	printf("Try -5 = q*2 + r\n");

	q = divE(-5, 2);
	r = modE(-5, 2);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(-5, 2);
	r = modF(-5, 2);
	printf("F-definition: q=%d, r=%d\n", q, r);

	q = divT(-5, 2);
	r = modT(-5, 2);
	printf("T-definition: q=%d, r=%d\n", q, r);


	// Try 5 = q*-2 + r
	printf("Try 5 = q*-2 + r\n");

	q = divE(5, -2);
	r = modE(5, -2);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(5, -2);
	r = modF(5, -2);
	printf("F-definition: q=%d, r=%d\n", q, r);

	q = divT(5, -2);
	r = modT(5, -2);
	printf("T-definition: q=%d, r=%d\n", q, r);


	// Try -5 = q*-2 + r
	printf("Try -5 = q*-2 + r\n");

	q = divE(-5, -2);
	r = modE(-5, -2);
	printf("E-definition: q=%d, r=%d\n", q, r);

	q = divF(-5, -2);
	r = modF(-5, -2);
	printf("F-definition: q=%d, r=%d\n", q, r);

	q = divT(-5, -2);
	r = modT(-5, -2);
	printf("T-definition: q=%d, r=%d\n", q, r);

}

void test_3()
{
	long q;
	long r;

	//https://julesjacobs.com/2023/09/23/on-div-and-mod.html
	// OK, the koka is E-definition
	printf("Try 8 = q*3 + r\n");
	q = divE(8, 3);
	r = modE(8, 3);
	printf("E-definition: q=%d, r=%d\n", q, r);

	printf("Try -8 = q*3 + r\n");
	q = divE(-8, 3);
	r = modE(-8, 3);
	printf("E-definition: q=%d, r=%d\n", q, r);

	printf("Try 8 = q*-3 + r\n");
	q = divE(8, -3);
	r = modE(8, -3);
	printf("E-definition: q=%d, r=%d\n", q, r);

	printf("Try -8 = q*-3 + r\n");
	q = divE(-8, -3);
	r = modE(-8, -3);
	printf("E-definition: q=%d, r=%d\n", q, r);

}

void test_4()
{
	long q;
	long r;

	printf("Try 8 = q*-3 + r\n");
	q = divE(8, -3);
	r = modE(8, -3);
	printf("E-definition: q=%d, r=%d\n", q, r);

	printf("Try -8 = q*-3 + r\n");
	q = divE(-8, -3);
	r = modE(-8, -3);
	printf("E-definition: q=%d, r=%d\n", q, r);

	//  option 2 is more natural for the div operator, 
	//	and it is easy to get the Euclidean mod using the floored mod: 
	//	mod_euclid(x,n) = x % abs(n). 
	//	I would argue that if your code is doing mod with negative divisors, 
	//	then it is in fact clearer to have that explicit abs in your code as a signifier 
	//	that something is going on.
	printf("\n");

	printf("Try 8 = q*-3 + r\n");
	q = divE(8, abs(-3));
	r = modE(8, abs(-3));
	printf("F-definition (with abs(-3)): q=%d, r=%d\n", q, r);

	printf("Try -8 = q*-3 + r\n");
	q = divE(-8, abs(-3));
	r = modE(-8, abs(-3));
	printf("F-definition (with abs(-3)): q=%d, r=%d\n", q, r);

}

int main()
{
//	test_0();
	test_1();
//	test_2();
//	test_3();
//	test_4();

	printf("E-definition r=%d\n", modE(-19, 4));

	getchar();

    return 0;
}

