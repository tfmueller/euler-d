module main;

import std.stdio,
    std.algorithm,
    std.range,
    std.conv,
    std.typecons,
    toolbox;

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
    return 600851475143UL
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

auto testproblem()
{
    return [[1, 2, 3], [4, 5, 6], [7, 8, 9, 10]].rsum;
}

void main(string[] args)
{
    problem6.writeln;
    
    // Lets the user press <Return> before program returns
    stdin.readln();
}
