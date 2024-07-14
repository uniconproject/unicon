# udb

Unicon's built-in debugger

# Starting udb

Usage: udb \[options] \[file]

\[file]: Name of the program to load once udb starts

Options:

--line: Run udb without interactive command line.

-h, --help: Prints usage details

Used with the debug adapter protocol client-server contexts, will not accept file argument:

--adapter \<port>: Run udb in adapter mode as a server on port.

--adapterfactory \<port>: A service used for creating udb adapter instances.

--dapproxy \<port>: A service for facilitating communication between a target program and a client embedded terminal over port.

# Adapter mode

When run in adapter mode udb uses local TCP sockets for communication. Udb acts as the server for both the client IDE on \<port> and the program handling debuggee I/O on \<port>+10.

So running `udb --adapter 5000` means udb will expect a connection from the client on port 5000 followed by a connection on port 5010 for debuggee I/O. In this case running `udb --dapproxy 5010` will create the client for the second connection.

# Using adapter mode without an IDE

Launch udb in adapter mode with `udb --adapter <port>`

Have your client program connect to \<port>. [example client program](#example-client-program)

Udb now expects the client to begin sending [Debug Adapter Procotol](https://microsoft.github.io/debug-adapter-protocol/specification) messages. Specifically:
1. an initialize request
2. a launch request
3. setBreakpoints request (if needed)
4. a successful runInTerminal response
5. a configurationDone request

Receiving a launch request prompts udb to open a connection on port \<port>+10 as a server and redirect the debuggee's I/O through it.

Receiving a successful runInTerminal response indicates to udb that dapproxy has connected to port \<port>+10 and is ready to handle debuggee I/O.

Receiving a configurationDone request prompts udb to run the debuggee and begin debugging.

Once udb has received the launch request and opened the connection on \<port?>+10, you can run `udb --dapproxy <port>+10` to connect to the socket for debuggee I/O.

**Note about requests**:<br />
Based on the [DAP documentation](https://microsoft.github.io/debug-adapter-protocol/overview) the launch request should be sent after the configurationDone request, but VSCode sends the launch request immediately after it receives an initialize response from udb. Udb does what setup it can after the actual launch request, but doesn't actually launch the debuggee until configuration is done. So the configurationDone request is what actually triggers launching the debuggee, since it is the last request sent by VSCode before debugging should start.

## Example client program

```
import json

procedure main(argv)
	port := (if &features == "MacOS" then "127.0.0.1" else "") || ":" || argv[1]
	prog := argv[2]
	sock := open(port, "n")
	
	init := [
		"seq": 1
		"type": "request"
		"command": "initialize"
		"arguments": [
			"adapterID": "udap"
		]
	]
	
	launch := [
		"command":"launch"
		"arguments":[
			"type":"unicon-debugger"
			"request":"launch"
			"name":"Launch in Unicon"
			"program":prog
		]
		"type":"request"
		"seq":2
	]
	
	run := [
		"type": "response"
		"seq":3
		"command":"runInTerminal"
		"request_seq":3
		"success": "__true__"
		"body": [
			"shellProcessId":1000
		]
	]
	
	config := [
	   "command":"configurationDone"
		"type":"request"
		"seq":4
	]
	
	msg := tojson(init)
	msg := "Content-Length: "||*msg||"\r\n\r\n"||msg
	writes(sock, msg)
	
	msg := tojson(launch)
	msg := "Content-Length: "||*msg||"\r\n\r\n"||msg
	writes(sock, msg)
	
	msg := tojson(run)
	msg := "Content-Length: "||*msg||"\r\n\r\n"||msg
	writes(sock, msg)
	
	msg := tojson(config)
	msg := "Content-Length: "||*msg||"\r\n\r\n"||msg
	writes(sock, msg)
	
	repeat every s := !select([sock, &input]) do
      writes(ready(s === sock)) | writes(sock, ready())
		
end
```

# Running udb in VSCode's extension development environment

Make sure you have an updated version of Node installed.

Clone the extension's repository and install dependencies:

```
git clone https://github.com/mstreeter10/vscode-unicon-debug.git
```
```
cd vscode-unicon-debug
```
```
npm i
```

Open the repo in VSCode.

Under "Run and Debug" select "Run Extension".

Within the development environment:
- open a unicon file
- Under Run and Debug select Run and Debug or create a launch.json file and select Launch in Unicon

# Basic Commands

`help` provides full usage details for all commands (except eval)

| Command       |                                                      |
| ------------- | ---------------------------------------------------- |
| udb [program] | Starts UDB and loads the executable program into it. |
| load program  | Loads a new program into udb.                        |
| run [arglist] | Executes the already loaded program [with arglist].  |
| break line    | Sets a breakpoint in the source code (line).         |
| break proc    | Sets a breakpoint at the entry of procedure (proc).  |
| where         | Backtraces and displays the current program stack.   |
| print expr    | Displays the value of (expr).                        |
| continue      | Resumes the program execution.                       |
| next          | Executes the next line and steps over any procedure. |
| step          | Executes the next line and steps into any procedure  |
| pstep         | Executes next pattern element that moves the cursor. |
| quit          | Quits the current UDB session.                       |
| help          | Shows more info about different commands.            |

## `eval <expr>`
Evaluates expression expr as Unicon code in the context of the current execution state (with side effects) and displays the result.

`eval` has access to all variables and functions within the current scope of the target program.

Expression failure is indicated by `"failure"` and runtime errors generated by expr will be displayed.