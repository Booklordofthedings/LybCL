using System;
namespace LybCL
{
	[AttributeUsage(.Method, .ReflectAttribute, ReflectUser=.Methods)]
	struct CommandableAttribute : Attribute
	{
		public String Name;
		public this(String name)
		{
			Name = name;
		}
	}
}