module main;

import std.stdio,
    std.algorithm,
    std.range,
    std.conv,
    std.typecons,
    toolbox,
    dataset;

auto problem1()
{
    return iota(1000)
        .filter!(x => !(x % 3) || !(x % 5))
        .sum;
}

auto problem2()
{
    return fibonacci(1, 2)
        .takeWhile!(x => x < 4_000_000)
        .filter!(x => !(x % 2))
        .sum;
}

auto problem3()
{
    return 600_851_475_143UL
        .primefacs[$ - 1];
}

auto problem4()
{
    return iota(101U, 1000U)
        .map!(x => iota(100U, x)
            .map!(y => (x * y)))
        .rfilter!ispalindrome
        .rmax;
}

auto problem5()
{
    return iota(20U, 0U, -1)
        .reduce!((acc, x) => lcm(acc, x));
}

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

auto problem7()
{
    return 100_0000U
        .primes
        .drop(10_000)
        .front;
}

auto problem8()
{
    return iotai(0, p8data.length - 13)
        .map!(x => p8data[x..x + 13]
            .map!(c => (c - '0').to!ulong)
            .prod)
        .max;
}

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

auto problem10()
{
    return 2_000_000UL.primes
        .sum;
}

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

auto testproblem()
{
    return 0;
}

void main(string[] args)
{
    problem11.writeln;
    
    // Lets the user press <Return> before program returns
    stdin.readln();
}
