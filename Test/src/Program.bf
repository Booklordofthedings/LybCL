namespace Test;
using System;
using System.Reflection;
using LybCL;
class Program
{
	public static void Main(String[] args)
	{
		var cl = scope LybCl(args);
		cl.HasFlag("verbose","v");
		Console.Read();
	}

	[CMDRouter("route")]
	public static void Test(bool t = true)
	{
		if(t)
			Console.WriteLine("fdsfd");
	}
}