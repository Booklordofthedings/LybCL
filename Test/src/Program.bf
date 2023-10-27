namespace Test;
using System;
using System.Reflection;
using LybCL;
[AlwaysInclude,Reflect]
class Program
{
	public static void Main(String[] args)
	{
		var cl = scope LybCl(args);
		cl.Route();
		Console.Read();
	}

	[CMDRouter("route {f}")]
	public static void Test(LybCl l,Float f)
	{
		Console.WriteLine("dsfdsfdsf");
	}
}