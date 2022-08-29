using System;

namespace LybCL;
/*
	Allows the user of the library to acess the parsed Arguments
	Command
	Values (inputs without names, like paths)
	Togggles
	Named Parameters
*/

class Arguments
{
	///Returns the parameter of a given index
	public static Result<String> GetParameter(int index)
	{
		return .Err;
	}

	///Returns the state of a toggleable parameter
	/// @param name To check multiple, just use a " " inbetween
	public static bool GetToggle(String name)
	{
		return false;
	}

	///The command the program was started with "default" if no know value was given
	public static StringView GetCommand()
	{
		return "";
	}

	///Get a parameter that has been predefined with --
	public static Result<String> GetNameParameter()
	{

	}


}