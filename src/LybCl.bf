/*
	[LybCL]
	Lyb Commandline library/tool
	Parses the String[] that a program starts with and allows the user to use the arguments easier
	Made by Booklordofthedings

	Usage:
		Everything starts by creating a commandline object and by passing in the String[]
		LybCl handles everything else and you only need to make sure to correctly dispose of it.

		GetArgs(int) returns the value of the args by index, if it exists. Otherwise it returns an empty stringview
		GetCommand() returns the command thats to be executed: ./Programname.exe {command} -parameters
		HasFlag(params StringView) checks wether a given flag is set as a value. returns a boolean
		GetParameter(params StringView) checks the value of a given parameter. Returns an empty string if its not found.
		RouteReturnCode{get;set} allows you to set the return value of the Route() call. only use inside one of the marked methods
		Route() Does reflection and calls functions that match the given route
			-Use CMDRouterAttriíbute on a static function to mark it as a routeable functions
			-The first attribute needs to be a LybCl type
			-Any other parameter needs to have be nullable (Type?) and have a Parse(StringView) function that returns a Result<T>
			-the route is made out of literals divided by spaces, while the required variables are to be included inside of curly brackets
				"generate new {a}" <- this route executes, if the user calls Program.exe generate new {any}. any being any value that will be parsed and inserted into the route

	Parameter design:
	[ProgramName] [Command] [Subcommand] [Parameter] [Arguments/Flags]
	[ProgramName] name of the program/exectuteable to run (test.exe/git)
	[Command]/[Subcommands] indicates the route or specific functionality to be executed. may be only one command (install) or multiple (get install) or any other lenght
	[Parameter] variable values that a command needs, like a filepath or url
	[Arguments/Flags] contain additional information that is not required but may change how the command executes. flags are only boolean while arguments have to contain
	an example call would be something like this

	./Program.exe repository generate "https://github.com/booklordofthedings/repo" --verbose --logfile log.txt


	some programs support arguments between the program name and command, however this tool does not
	if you want to do global settings that apply to every command you can simply put them at the end of the command
	and just read them in before doing any processing or routing, to set them
*/
namespace LybCL;
using System;
using System.Reflection;
using System.Collections;
class LybCl
{
	private String[] _args;
	private Dictionary<String, String>  _parameters = new .() ~ DeleteDictionaryAndKeysAndValues!(_);
	private CMDRouterAttribute _attributeInfo;

	public this(String[] pArgs)
	{
		_args = pArgs;
		for(int i < _args.Count)
		{
			if(!_args[i].StartsWith('-'))
				continue;

			int endIndex = -1;
			for(int j < _args[i].Length)
			{
				if(_args[i][j] != '-')
				{
					endIndex = j;
					break;
				}
			}

			if(endIndex < 0)
				continue;

			StringView name = .(_args[i],endIndex);

			if(!(i+1 < _args.Count) || _args[i+1].StartsWith('-'))
			{
				_parameters.Add(new .(name), new .(""));
				continue;
			}

			_parameters.Add(new .(name), new .(_args[i+1]));
			i++;
		}
	}

	//Allows users to set what the call for route will return
	public int RouteReturnCode { get; set; } = 0;

	public int Count
	{
		public get {
			return _args.Count;
		}
	}

	///Get the raw argument at the given index or an empty string
	public StringView GetArgs(int pIndex)
	{
		if(pIndex < 0 || !(pIndex < _args.Count))
			return "";
		else
			return _args[pIndex];
	}

	///Get the command or an empty string
	public StringView GetCommand()
	{
		if(_args.Count < 1)
			return "";
		else if(!_args[0].StartsWith('-'))
			return _args[0];
		else
			return "";
	}

	///Get wether a specific flag is set, allows aliases
	public bool HasFlag(params Span<StringView> pArgs)
	{
		for(var arg in pArgs)
		{
			if(!_parameters.ContainsKey(scope .(arg)))
				continue;

			if(_parameters[scope .(arg)] == "")
				return true;
		}
		return false;
	}

	///Gets the value of a argument and returns empty if not found
	public StringView GetParameter(params Span<StringView> pArgs)
	{
		for(var arg in pArgs)
		{
			if(!_parameters.ContainsKey(scope .(arg)))
				continue;
			return _parameters[scope .(arg)];
		}
		return "";
	}

	///Process all of the reflected and routed methods and tries to find one that matches, then it calls it
	public void Route()
	{
		for(let type in Type.Types)
		{
			m: for(let method in type.GetMethods())
			{
				let attributeInfo = method.GetCustomAttribute<CMDRouterAttribute>();
				if(attributeInfo case .Err)
					continue;
				_attributeInfo = attributeInfo.Value;
				//Ensure that the route works
				var routingList = scope List<StringView>();
				attributeInfo.Value.GetRouteList(routingList);
				r: for(int i < routingList.Count)
				{
					if(!(i < _args.Count))
						continue m;

					if(routingList[i].StartsWith('{') && routingList[i].EndsWith('}'))
						continue r;

					if(routingList[i] != _args[i])
						continue m;
				}

				Object[] args = scope Object[method.ParamCount];
				for(int i = 0; i < method.ParamCount; i++)
				{
					if(i == 0)
					{
						args[i] = this;
						continue;
					}
					for(var fd in method.GetParamType(i).GetMethods())
					{
						Console.WriteLine(fd.Name);
					}
					args[i] = null;
				}
				var res = method.Invoke(null, params args);
				res.Dispose();
			}
		}
	}

	public StringView GetValue(StringView pVal)
	{
		var route = scope List<StringView>();
		_attributeInfo.GetRouteList(route);
		for(int i < route.Count)
		{
			if(route[i] == scope $"\{{pVal}\}")
			{
				if(i < _args.Count)
					return _args[i];
			}
		}
		return "";
	}
}

[AttributeUsage(.Method, .AlwaysIncludeTarget | .ReflectAttribute, ReflectUser=.All), AlwaysInclude]
struct CMDRouterAttribute : Attribute, IOnMethodInit
{
	private String _route;
	public this(String pRoute)
	{
		_route = pRoute;
	}

	public void GetRouteList(List<StringView> pBuffer)
	{
		var seperationChars = scope char8[](' ','\t');
		var enumerator = _route.Split(seperationChars,.RemoveEmptyEntries);
		for(let entry in enumerator)
			pBuffer.Add(entry);
	}

	[Comptime]
	public void OnMethodInit(MethodInfo methodInfo, Self* prev)
	{
		
		String toAppend = scope .();
		for(int i = 1; i < methodInfo.ParamCount; i++)
		{

			//Remove nullable
			var t = methodInfo.GetParamType(i) as SpecializedGenericType;

			toAppend.Append(scope $"""
				var {methodInfo.GetParamName(i)};
				let parseResult{methodInfo.GetParamName(i)} = {t.GetGenericArg(0).GetFullName(.. scope .())}.Parse(cl.GetValue("{methodInfo.GetParamName(i)}"));
				if(parseResult{methodInfo.GetParamName(i)} case .Err)
					return;
				{methodInfo.GetParamName(i)} = ({methodInfo.GetParamType(i)})parseResult{methodInfo.GetParamName(i)}.Value;

				""");
		}
		Compiler.EmitMethodEntry(methodInfo, toAppend);
	}
}


/*
	Here are the types that dont have a 
*/
namespace System
{
	extension StringView
	{
		public static Result<StringView> Parse(StringView pInput)
		{
			return .Ok(pInput);
		}
	}
}
