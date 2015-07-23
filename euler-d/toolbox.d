module toolbox;

import std.algorithm,
	std.typecons,
	std.traits,
	std.range,
	std.array,
	std.conv,
	std.math,
	std.stdio;

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

auto tmap(R)(R r)
	if((RangeDim!R == 1) && isTuple!(ElementType!R))
{
	return r.map!(t => t.bind!f);
}

auto tfilter(R)(R r)
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

auto sum(R)(R r){	return r.reduce!((acc, x) => acc + x); }
auto prod(R)(R r){	return r.reduce!((acc, x) => acc * x); }
auto max(R)(R r){	return r.reduce!((acc, x) => acc > x ? acc : x); }
auto min(R)(R r){	return r.reduce!((acc, x) => acc < x ? acc : x); }

auto rsum(R)(R r){	return r.rreduce!((acc, x) => acc + x); }
auto rprod(R)(R r){	return r.rreduce!((acc, x) => acc * x); }
auto rmax(R)(R r){	return r.rreduce!((acc, x) => acc > x ? acc : x); }
auto rmin(R)(R r){	return r.rreduce!((acc, x) => acc < x ? acc : x); }

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

bool ispalindrome(T)(T num)
	if(isUnsigned!T)
{
	return num.to!string
		.apply!(ns => ns.retro
			.equal(ns));
}
