from tephrite import VERSION

alias USAGE = """\
Usage: tephrite [arguments]
Arguments:

	b | build
		Builds a Conda package.
	
	v | version
		Prints the version of this package.
"""

alias EXIT_SUCCESS = 0
alias EXIT_FAILURE = 1
alias EXIT_INFO = 2

fn run(args: VariadicList[StringRef]) raises -> Int:
	alias ARG_STATE_COMMAND = 0
	alias ARG_STATE_NEW = 1

	if len(args) < 2:
		print_usage()
		return EXIT_INFO
	
	var argx = 0
	var arg_state = ARG_STATE_COMMAND
	for arg in args:
		if arg_state == ARG_STATE_COMMAND: # do nothing with the command name
			arg_state = ARG_STATE_NEW
		elif arg_state == ARG_STATE_NEW: # new argument sequence
			if arg == "b" or arg == "build":
				var builder = Builder()
				builder.build()
				arg_state = ARG_STATE_NEW
			elif arg == "v" or arg == "version":
				print(VERSION)
				arg_state = ARG_STATE_NEW
			else:
				print_usage()
				return EXIT_FAILURE
		else:
			raise Error("invalid argument state " + str(arg_state) + " at index " + str(argx))
		argx += 1

	if arg_state != ARG_STATE_NEW: # last argument not complete
		print_usage()
		return EXIT_FAILURE
	
	return EXIT_SUCCESS

fn print_usage():
	print(USAGE, end="")
