## LybCL
A simple to use Command line parsing library for the beef programming language

### How to use
- Mark static command functions with the attribute
- Call generate with the args[] being passed in
- Call the getParameter type functions while in the command function to get info about other parameters

### Example
```cs
Program.exe make "dir/text.txt" "test.js" -v c b --out_dir "dist/test" --log_file "log.txt"
```

