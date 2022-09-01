## LybCL
A simple to use Command line parsing library for the beef programming language

### How to use
- Mark static command functions with the attribute
- Call generate with the args[] being passed in
- Call the getParameter type functions while in the command function to get info about other parameters

### Example
```
Program.exe make "dir/text.txt" "test.js" -v c b --out_dir "dist/test" --log_file "log.txt"

1st: The name of the program (not handled by lybcl)
2nd: Command to execute on the program (registered with the attribute, if no fit is found on the registered attributes a default one will be called)
3rd: Required parameter 1 and 2 for the command they dont need to be specified and can be acessed by index
4th: Optional toggles, will return false if not there and true if there
	Can be specified with a "-" per command or just one "-" and spaces inbetween
5th: Named parameter can be optional or required and is acessible by its name
```

