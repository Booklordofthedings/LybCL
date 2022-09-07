## LybCL
A simple to use Command line parsing library for the beef programming language

### How to use
- Create a commandline object and pass in the args[] into the constructor
- Acess the parsed data on the commandline object using the methods

### Available methods:
getCommand: returns the command that has been identified or "Default" if no command was given
getArgument: returns the required parameter by index
getFlag: returns wether a specific flag has been set
getParameter: returns a named paramter if it has been set

```
Program.exe install "c://programs/test" -v -h -g -name test

command = install
argument[0] = c://programs/test"
flags = v, h, g
parameter = name: test
```
