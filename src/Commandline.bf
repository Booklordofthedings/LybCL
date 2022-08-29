using System;
using System.Collections;
using System.Reflection;
namespace LybCL
{
	class Commandline
	{
		/*
		Rules:
		- = toggle parameter (-v)
		-- = value parameter (--path "c://item.txt")
		-a d c b = -a -b -c -d
		*/

		private static Dictionary<String, MethodInfo> RegisteredCommands; //All commands are in here

		/// Only method needed to be called by the user
		/// @param args args from the main method
		public static void HandleArgs(String[] args)
		{
			RegisteredCommands = Generate(); //Registering

			//Parse the args
			ArgsParser.ParseArgs(args);

			//Cleanup
			DeleteDictionaryAndKeys!(RegisteredCommands);
		}
	}
}