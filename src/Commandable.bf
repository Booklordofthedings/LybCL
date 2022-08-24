using System;
namespace LybCL
{
	[AttributeUsage(.Method, .ReflectAttribute, ReflectUser=.All, AlwaysIncludeUser=.All)]
	struct CommandableAttribute : Attribute
	{
		public String Name;
		public this(String name)
		{
			Name = name;
		}
	}
}