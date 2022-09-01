using System;
using System.Collections;
namespace LybCL;

class CommandlineArgs
{
	public static CommandlineArgs current;

	private String Command;
	private List<String> Toggles; //All toggles applied
	private Dictionary<String, String> Parameters; //Named parameters
	private String[] Args; //Copy of the args string, used for integer acess


	///We parse on creation so this is fine
	///@param callCommands if this is true the program will call marked methods via reflection
	public this(String[] args, bool callCommands = false)
	{
		Command = args[0]; //Later validate, wether this actually is a valid command
		for(int i = 0; i < args.Count; i++)
		{
			if(args[i].StartsWith("--")) //Named parameter
			{
				StringView paramName = args[i].Substring(2);
				StringView paramValue;
				if(!(i++ < args.Count)) //If there is a next one
					continue;
			}
			else if(args[i].StartsWith("-")) //Toggle
			{

			}
			else //Args
			{

			}
		}
	}

	///Returns wether a specific toggle has been passed in as a parameter
	///@param search can contain multiple tokens, seperated by a space. True if one of them is there
	public bool getToggle(String search)
	{
		return true;
	}

	///Returns the value of a specific parameter
	///@param search can contain multiple tokens, seperated by a space. Returns if one of them is there
	public Result<String> getParam(String search)
	{
		return .Err;
	}

	///Returns something that may be the command
	public String getCommand()
	{
		return "";
	}

	//Acess parameters by array, usefull for required parameters
	public Result<String> this[int index]
	{

	}
}