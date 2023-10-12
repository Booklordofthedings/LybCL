using System;
using System.Collections;
namespace LybCL;

class CommandLine
{
	private String _command;

	private List<String> _arguments;
	private List<String> _toggles;
	private Dictionary<String, String> _namedParams;

	public this(String[] args)
	{
		_arguments = new .();
		_toggles = new .();
		_namedParams = new .();
		//Get the command that is supposed to be executed
		if(args.Count == 0)
		{
			_command = new String("Default");
			return;
		}
		else if(args[0].StartsWith("-"))
			_command = new String("Default");
		else
			_command = new String(args[0]);

		int argsEnd = 0;
		for(int i = (_command == "Default") ? 0 : 1 ; i < args.Count; i++)
		{
			if(args[i].StartsWith("-"))
			{
				argsEnd = i;
				break;
			}

			_arguments.Add(new .(args[i]));
		} //Now we should have fully parsed unnnamed arguments

		for(int i = argsEnd; i < args.Count; i++)
		{
			if(args[i].StartsWith("--") && i++ < args.Count) //Named param
			{
				String name = new .(args[i]);
				name.Remove(0,2);
				String value = new .(args[i+1]);
				_namedParams.TryAdd(name, value); //TODO: Error chekcing
				i++;
			}
			else if(args[i].StartsWith("-")) //Toggle parameter
			{
				String param = new String(args[i]);
				param.Remove(0,1);
				_toggles.Add(param);

				while(i < args.Count && args[i].StartsWith("-"))
				{
					String temp = new String(args[i]);
					_toggles.Add(temp);
					i++;
				}
			}	
		}

	}

	public ~this()
	{
		delete _command;
		DeleteContainerAndItems!(_arguments);
		DeleteContainerAndItems!(_toggles);
		DeleteDictionaryAndKeysAndValues!(_namedParams);
		//This should clean up everything
	}

	///Returns what has been assumed to be the command or "Default"
	public StringView getCommand()
	{
		return _command;
	}

	///Tries to get the default argument
	public Result<StringView> getArgument(int n)
	{
		if(n < _arguments.Count && !(n < 0))
		{
			return .Ok(_arguments[n]);
		}

		return .Err;
	}

	///Returns wether a specific flag has been set
	public bool getFlag(String search)
	{
		StringSplitEnumerator e = search.Split(' '); //Search entries are seperated by a ' '
		bool output = false;
		for(let i in e)
		{
			if(_toggles.Contains(scope .(i)))
				output = true;
		}
		return output;
	}

	public Result<StringView> getParameter(String search)
	{
		StringSplitEnumerator e = search.Split(' '); //Search entries are seperated by a ' '
		for(let i in e)
		{
			if(_namedParams.ContainsKey(scope .(i)))
			{
				return .Ok(_namedParams[scope .(i)]);
			}
		}
		return .Err;
	}
}