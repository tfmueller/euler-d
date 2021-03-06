﻿module toolbox;

import std.algorithm,
    std.typecons,
    std.traits,
    std.range,
    std.array,
    std.conv,
    std.math,
    std.numeric,
    std.bigint;

auto apply(alias f, T...)(T t)
    if(is(typeof(f(t))))
{
    static if(is(typeof(f(t)) == void))
    {
        f(t);
        return 0;
    }
    else
    {
        return f(t);
    }
}

auto bind(alias f, T)(T t)
    if(isTuple!T)
{
    return t.expand
        .apply!f;
}

auto flip(alias f, T, U...)(U u, T t)
    if(is(typeof(f(t, u))))
{
    return fuse(t, u).expand
        .apply!f;
}

auto fuse(T, U)(T t, U u)
{
    static if(isTuple!T)
    {
        static if(isTuple!U)
        {
            return tuple(t.expand, u.expand);
        }
        else
        {
            return tuple(t.expand, u);
        }
    }
    else
    {
        static if(isTuple!U)
        {
            return tuple(t, u.expand);
        }
        else
        {
            return tuple(t, u);
        }
    }
}

template RangeDim(T)
{
    static if(isInputRange!T)
    {
        alias E = ElementType!T;
        immutable RangeDim = 1 + RangeDim!E;
    }
    else
    {
        immutable RangeDim = 0;
    }
}

template RElementType(R)
{
    static if(RangeDim!R > 0)
    {
        alias E = ElementType!R;
        alias RElementType = RElementType!E;
    }
    else
    {
        alias RElementType = R;
    }
}

auto rreduce(alias f, R)(R r)
    if(RangeDim!R > 0)
{
    static if(RangeDim!R > 1)
    {
        return r.map!(e => e.rreduce!f)
            .reduce!f;
    }
    else
    {
        return r.reduce!f;
    }
}

auto rmap(alias f, R)(R r)
    if(RangeDim!R > 0)
{
    static if(RangeDim!R > 1)
    {
        return r.map!(e => e.rmap!f);
    }
    else
    {
        return r.map!f;
    }
}

auto rfilter(alias f, R)(R r)
    if(RangeDim!R > 0)
{
    static if(RangeDim!R > 1)
    {
        return r.map!(e => e.rfilter!f)
            .filter!(e => !e.empty);
    }
    else
    {
        return r.filter!f;
    }
}

auto tmap(alias f, R)(R r)
    if((RangeDim!R == 1) && isTuple!(ElementType!R))
{
    return r.map!(t => t.bind!f);
}

auto tfilter(alias f, R)(R r)
    if((RangeDim!R == 1) && isTuple!(ElementType!R))
{
    return r.filter!(t => t.bind!f);
}

auto trmap(alias f, R)(R r)
    if(RangeDim!R > 0)
{
    static if(RangeDim!R > 1)
    {
        return r.map!(e => e.trmap!f);
    }
    else
    {
        return r.tmap!f;
    }
}

auto trfilter(alias f, R)(R r)
    if(RangeDim!R > 0)
{
    static if(RangeDim!R > 1)
    {
        return r.map!(e => e.trfilter!f)
            .filter!(e => !e.empty);
    }
    else
    {
        return r.tfilter!f;
    }
}

auto fibonacci(T)(T first, T second)
{
    return tuple(first, second)
        .expand
        .recurrence!((a, n) => a[n - 2] + a[n - 1]);
}

auto prod(R)(R r){  return r.reduce!((acc, x) => acc * x); }
auto max(R)(R r){   return r.reduce!((acc, x) => acc > x ? acc : x); }
auto min(R)(R r){   return r.reduce!((acc, x) => acc < x ? acc : x); }

auto rsum(R)(R r){  return r.rreduce!((acc, x) => acc + x); }
auto rprod(R)(R r){ return r.rreduce!((acc, x) => acc * x); }
auto rmax(R)(R r){  return r.rreduce!((acc, x) => acc > x ? acc : x); }
auto rmin(R)(R r){  return r.rreduce!((acc, x) => acc < x ? acc : x); }

auto takeWhile(alias f, R)(R r)
    if((RangeDim!R == 1) &&
       is(typeof(f(r.front)) == bool))
{
    return r.take(r.countUntil!(e => !f(e)));
}

auto dropWhile(alias f, R)(R r)
    if((RangeDim!R == 1) &&
       is(typeof(f(r.front)) == bool))
{
    return r.drop(r.countUntil!(e => !f(e)));
}

auto isqrt(T)(T num)
    if(isIntegral!T)
{
    return num.to!real
        .sqrt
        .to!T;
}

T[] primefacs(T)(T num)
    if(isUnsigned!T)
{
    if(num == 1)
    {
        return T[].init;
    }
    if(num == 2)
    {
        return [2.to!T];
    }
    
    return num.isqrt
        .apply!(ns => iota(2.to!T, ns)
            .chain(num.only)
            .filter!(x => !(num % x))
            .front
            .apply!(x => [x] ~ (num / x).primefacs));
}

auto lcm(T)(T x, T y)
    if(isIntegral!T)
{
    return x * y / gcd(x, y);
}

bool ispalindrome(T)(T num)
    if(isUnsigned!T)
{
    return num.to!string
        .apply!(ns => ns.retro
            .equal(ns));
}

T[] primes(T)(T num)
    if(isUnsigned!T)
{
    if(num <= 2)
    {
        return [2];
    }

    return num.isqrt
        .apply!(ns => ns.primes
            .apply!((in nsp) => nsp
                .chain(iota(ns, num + 1)
                    .filter!(n => nsp.all!(x => n % x)))))
        .array;
}

auto iotai(T)(T start, T end, T step = 1.to!T)
    if(isIntegral!T)
{
    return iota(start, end + ((end - start) % step ? 0.to!T : step), step);
}

auto rfront(R)(R r)
    if(RangeDim!R > 0)
{
    static if(RangeDim!R > 1)
    {
        return r.front
            .rfront;
    }
    else
    {
        return r.front;
    }
}

auto triangle()
{
    return tuple(1UL, 2)
        .recurrence!((a, n) => a[n - 1]
            .bind!((tri, add) => tuple(tri + add, add + 1)))
        .tmap!((tri, add) => tri);
}

auto factorial(T)(T t)
    if(isUnsigned!T)
{
    if(t == 0.to!T)
    {
        return 1.to!BigInt;
    }

    return iotai(1.to!T, t)
        .map!(x => x.to!BigInt)
        .prod;
}

auto ncr(T)(T n, T r)
    if(isUnsigned!T)
{
    return (n.factorial / (r.factorial * (n - r).factorial))
        .toLong
        .to!T;
}