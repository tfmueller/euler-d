module main;

import std.stdio,
    std.algorithm,
    std.range,
    std.conv,
    std.typecons,
    std.bigint,
    toolbox,
    dataset;

//Add all the natural numbers below 1000 that are multiples of 3 or 5.
auto problem1()
{
    return iota(1000)
        .filter!(x => !(x % 3) || !(x % 5))
        .sum;
}

//Find the sum of all the even-valued terms in the Fibonacci < 4 million.
auto problem2()
{
    return fibonacci(1, 2)
        .takeWhile!(x => x < 4_000_000)
        .filter!(x => !(x % 2))
        .sum;
}

//Find the largest prime factor of a composite number.
auto problem3()
{
    return 600_851_475_143UL
        .primefacs[$ - 1];
}

//Find the largest palindrome made from the product of two 3-digit numbers.
auto problem4()
{
    return iota(101U, 1000U)
        .map!(x => iota(100U, x)
            .map!(y => (x * y)))
        .rfilter!ispalindrome
        .rmax;
}

//What is the smallest positive number that is evenly divisible by all of
//the numbers from 1 to 20?
auto problem5()
{
    return iota(20U, 0U, -1)
        .reduce!((acc, x) => lcm(acc, x));
}

//Find the difference between the sum of the squares of the first one 
//hundred natural numbers and the square of the sum.
auto problem6()
{
    return tuple(1, 100)
        .bind!((x, y) => tuple(
            iota(x, y + 1)
                .map!(n => n ^^ 2)
                .sum,
            iota(x, y + 1)
                .sum
                .apply!(n => n ^^ 2))
            .bind!((sumofsquares, squareofsums) =>
                squareofsums - sumofsquares));
}

//What is the 10001st prime number?
auto problem7()
{
    return 100_0000U
        .primes
        .drop(10_000)
        .front;
}

//Find the greatest product of thirteen consecutive digits in the 1000-digit number.
auto problem8()
{
    return iotai(0, p8data.length - 13)
        .map!(x => p8data[x..x + 13]
            .map!(c => (c - '0').to!ulong)
            .prod)
        .max;
}

//There exists exactly one Pythagorean triplet for which a + b + c = 1000.
//Find the product abc.
auto problem9()
{
    return iota(1, 1000)
        .map!(x => iota(x + 1, 1000)
            .map!(y => tuple(x, y, 1000 - x - y)))
        .trfilter!((x, y, z) => (y < z) && (x^^2 + y^^2 == z^^2))
        .rfront
        .expand
        .only
        .prod;
}

//Find the sum of all the primes below two million.
auto problem10()
{
    return 2_000_000UL.primes
        .sum;
}

//What is the greatest product of four adjacent numbers in any direction
//(up, down, left, right, or diagonally) in the 20x20 grid?
auto problem11()
{
    return tuple(p11data.length, p11data[0].length)
        .bind!((nrows, ncols) =>
            only(tuple(0, ncols - 3, 0, nrows,      1, 0),
                 tuple(0, ncols - 3, 0, nrows - 3,  1, 1),
                 tuple(0, ncols,     0, nrows - 3,  0, 1),
                 tuple(3, ncols,     0, nrows - 3, -1, 1))
            .tmap!((xstart, xend, ystart, yend, xstep, ystep) => iota(xstart, xend)
                .map!(x => iota(ystart, yend)
                    .map!(y => iotai(0, 3)
                        .map!(n => p11data[y + n*ystep][x + n*xstep])
                        .prod))))
        .rmax;
}
//What is the value of the first triangle number to have over five
//hundred divisors?
auto problem12()
{
    return triangle
        .drop(1)
        .map!(tri => tuple(tri, tri.primefacs
            .apply!((in r) => r.uniq
                .apply!((in u) => u
                    .map!(uf => r
                        .count!(rf => rf == uf) + 1)
                    .prod))))
        .dropWhile!(t => t
            .bind!((tri, nf) => nf <= 500))
        .front
        .bind!((tri, nf) => tri);
}

//Work out the first ten digits of the sum of the following one hundred
//50-digit numbers.
auto problem13()
{
    return p13data
        .map!((in s) => s.to!BigInt)
        .sum
        .toDecimalString
        .take(10);
}

//The following iterative sequence is defined for the set of positive 
//integers: n -> n/2 (n is even), n -> 3n + 1 (n is odd). Which starting 
//number, under one million, produces the longest chain?
auto problem15()
{
    return tuple(20UL, 20UL)
        .bind!((x, y) => (x + y).ncr(x));
}

auto testproblem()
{
    return 0;
}

void main(string[] args)
{
    problem15.writeln;
    
    // Lets the user press <Return> before program returns
    stdin.readln();
}
