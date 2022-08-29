using System;
namespace LybCL
{
	[AttributeUsage(.Method, .ReflectAttribute, ReflectUser=.All, AlwaysIncludeUser=.All)]
	struct CommandableAttribute : Attribute
	{
		public String Name; //How to adress the code
		public this(String name, bool asDefault = false)
		{
			Name = name;
		}
	}
}