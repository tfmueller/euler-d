﻿module main;

import std.stdio,
	std.algorithm,
	std.range,
	std.conv,
	std.string,
	std.array,
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

void main(string[] args)
{
	problem2.writeln;
	
	// Lets the user press <Return> before program returns
	stdin.readln();
}
