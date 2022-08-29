using System;
using System;
using System.Reflection;
using System.FFI;
using System.Diagnostics;
using System.Collections;
namespace LybCL
{
	extension Commandline
	{
		
		private static Dictionary<String, MethodInfo> Generate()
		{
			Dictionary<String, MethodInfo> RegisteredCommands = new .(); //All commands are in here

			for (let type in Type.Types)
			{
			    
			        for (let method in type.GetMethods(.Static))
			        {
			           if(method.GetCustomAttribute<CommandableAttribute>() case .Ok )
						{
							Result<CommandableAttribute> a = method.GetCustomAttribute<CommandableAttribute>();
							StringSplitEnumerator e = a.Value.Name.Split(' ');
							for(StringView s in e)
							{
								RegisteredCommands.Add(new .(s), method); //This is pretty unsafe
								//We are not handling errors corretly but that is on the implementer
								//of the library, not us
							}
						}
			        }
			}
			return RegisteredCommands;
		}
	}
}