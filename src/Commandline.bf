using System;
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

		/// Only method needed to be called by the user
		/// @param args args from the main method
		public static Result<void> HandleArgs(String[] args)
		{
			Generate();
			//Map arguments and functiosn to 
			return .Ok;
		}
	}
}