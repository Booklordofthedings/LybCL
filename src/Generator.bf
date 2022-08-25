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
		
		private static void Generate()
		{
			for (let type in Type.Types)
			{
			    
			        for (let method in type.GetMethods(.Static))
			        {
						//Console.WriteLine(method.Name);
						
			           if(method.GetCustomAttribute<CommandableAttribute>() case .Ok )
						{
							Result<Variant, MethodInfo.CallError> t = method.Invoke(null);
						}
						
			        }
			}
		}
	}
}