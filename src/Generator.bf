using System;
namespace LybCL
{
	class Generator
	{
		
		public static void Generate()
		{
			for (let type in Type.Types)
			{
			    
			        for (let method in type.GetMethods(.Static))
			        {
			           if(method.GetCustomAttribute<CommandableAttribute>() case .Ok )
							Console.WriteLine(method.Name);
			        }
			}
		}
	}
}