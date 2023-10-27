namespace LybCL;
using System;
using System.Collections;
/*
	[LybCL]
	Lyb Commandline library/tool
	Parses the String[] that a program starts with and allows the user to use the arguments easier
	Made by Booklordofthedings

	Usage:
		Everything starts by creating a commandline object and passing in the String[]
		LybCl handles everything else and you only need to make sure to correctly dispose of it.

		GetArgs(int) returns the value of the args by index, if it exists. Otherwise it returns an empty stringview
		GetCommand() returns the command thats to be executed: ./Programname.exe {command} -parameters

*/

class LybCl
{
	private String[] _args;

	public this(String[] pArgs)
	{
		_args = pArgs;
	}

	///Wether values are allowed to have one or mode leading minus'
	/// --path --other //If its true it will return "--other" as a value for "path"
	public bool AllowLeadingMinusInValue { get; set; } = false;

	public int Count
	{
		public get {
			return _args.Count;
		}
	}

	///Get the arguments by id. Empty if it doesnt exist
	public StringView GetArgs(int pIndex)
	{
		if(pIndex < 0 || !(pIndex < _args.Count))
			return "";
		else
			return _args[pIndex];
	}

	///Get the main command
	public StringView GetCommand()
	{
		if(_args.Count < 1)
			return "";
		else if(!_args[0].StartsWith('-'))
			return _args[0];
		else
			return "";
	}

	///Wether a specific flag is set by alias
	public bool HasFlag(params Span<StringView> pArgs)
	{
		for(int i < _args.Count)
		{
			if(_args[i].StartsWith('-'))
			{
				for(let match in pArgs)
				{
					var match1 = scope $"-{match}";
					var match2 = scope $"--{match}";

					if(_args[i] == match1 || _args[i] == match2)
						return true;
				}
			}
		}
		return false;
	}

	///Gets the value of a paramter by name or alias. Empty if not available
	public StringView GetParameter(params Span<StringView> pArgs)
	{
		StringView toReturn = "";
		for(int i < _args.Count)
		{
			if(_args[i].StartsWith('-'))
			{
				for(let match in pArgs)
				{
					var match1 = scope $"-{match}";
					var match2 = scope $"--{match}";

					if(!(_args[i] == match1) &&  !(_args[i] == match2))
						continue;
					
					if(!(i+1 < _args.Count))
						continue;

					if(_args[i+1].StartsWith('-') && !AllowLeadingMinusInValue)
						continue;

					toReturn = _args[i+1];
				}
			}
		}
		return toReturn;
	}

	///Process the routes set via the attribute and calls relevant functions
	public void Route()
	{
		for(let type in Type.Types)
		{
			for(let method in type.GetMethods(.Static))
			{
				Console.WriteLine(method.Name); //This should simply output every reflected method
				var attributeInfo = method.GetCustomAttribute<CMDRouterAttribute>();
				if(attributeInfo case .Err)
					return;

				var route = attributeInfo.Value.Route;
				List<(StringView,StringView)> fields = scope .();
				var res = _MatchRoute(route, _args, fields);
				if(res case .Err)
					continue;

				Object[] arr = scope Object[method.ParamCount];
				for(int i = 0; i < method.ParamCount; i++)
				{
				 	if(i == 0)
					{
						arr[i] = this;
						continue;
					}

					var paramType = method.GetParamType(i);
					var paramName = method.GetParamName(i);

					StringView paramValue = "";
					for(let pair in fields)
					{
						if(pair.0 != paramName)
							continue;
						paramValue = pair.1;
					}
					if(paramValue == "")
						return;

					for(let ifaces in paramType.Interfaces)
					{
						if(ifaces.GetName(..scope .()) == "IParseAble")
						{
							var re = paramType.GetMethod("LybParse", .Static).Value.Invoke(null,paramValue);
							if(re case .Err)
								return;
							arr[i] = re.Value.DataPtr;
						}
					}
				}

				method.Invoke(null,arr);
			}
		}

	}

	///Checks wether 2 routes match up and returns a key value pair for parsing inputs
	private Result<void> _MatchRoute(StringView pRoute, String[] pArgs, List<(StringView,StringView)> pOut)
	{
		var enumerator = pRoute.Split(scope char8[](' ','\t'),.RemoveEmptyEntries);
		args: for(let entry in enumerator)
		{
			if(@entry.MatchIndex >= pArgs.Count)
				return .Err; //The route has more required fields than we have args

			if(entry.StartsWith('{') && entry.EndsWith('}'))
			{ //Variable arguments
				pOut.Add((
					.(entry,1,entry.Length-2),
					pArgs[@entry.MatchIndex]
					));
				continue args;
			}

			if(!(entry == pArgs[@entry.MatchIndex]))
				return .Err;
		}
		return .Ok;

	}

}

[AttributeUsage(.Method, .AlwaysIncludeTarget | .ReflectAttribute, ReflectUser=.All), AlwaysInclude]
struct CMDRouterAttribute : Attribute
{
	public String Route;

	public this(String pRoute, bool pCaseSensitivity = false)
	{
		Route = pRoute;
	}
}


namespace System
{
	[Reflect,AlwaysInclude]
	interface IParseAble
	{
		[Reflect,AlwaysInclude]
		public static Result<Variant> LybParse(StringView pValue);
	}

	extension Float : IParseAble
	{
		public static System.Result<System.Variant> LybParse(StringView pValue)
		{
			var res = Float.Parse(pValue);
			if(res case .Err)
				return .Err;
			return .Ok(Variant.Create(res.Value));
		}
	}
}