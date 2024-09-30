from tephrite import VERSION
from .publisher import Publisher

alias USAGE = """\
Usage: tephrite [arguments]
Arguments:

	b | build <dir>
		Build a Conda package from the recipe in directory <dir>.
	
	p | publish
		Publish a Conda package built from the recipe.
	
	v | version
		Print the version of this package.
"""

alias EXIT_SUCCESS = 0
alias EXIT_FAILURE = 1
alias EXIT_INFO = 2

fn run(args: VariadicList[StringRef]) raises -> Int:
	alias ARG_STATE_COMMAND = 0
	alias ARG_STATE_NEW = 1
	alias ARG_STATE_BUILD = 2

	if len(args) < 2:
		print_usage()
		return EXIT_INFO
	
	var argx = 0
	var arg_state = ARG_STATE_COMMAND
	for arg in args: # simple state machine TODO simplify to varying number of arguments
		if arg_state == ARG_STATE_COMMAND: # do nothing with the command name
			arg_state = ARG_STATE_NEW
		elif arg_state == ARG_STATE_NEW: # new argument sequence
			if arg == "b" or arg == "build":
				arg_state = ARG_STATE_BUILD
			elif arg == "p" or arg == "publish":
				publisher = Publisher()
				publisher.publish()
				arg_state = ARG_STATE_NEW
			elif arg == "v" or arg == "version":
				print(VERSION)
				arg_state = ARG_STATE_NEW
			else:
				print_usage()
				return EXIT_FAILURE
		elif arg_state == ARG_STATE_BUILD: # build package
			builder = Builder()
			_ = builder.build(arg) # TODO handle package path
			arg_state = ARG_STATE_NEW
		else:
			raise Error("invalid argument state " + str(arg_state) + " at index " + str(argx))
		argx += 1

	if arg_state != ARG_STATE_NEW: # last argument not complete
		print_usage()
		return EXIT_FAILURE
	
	return EXIT_SUCCESS

fn print_usage():
	print(USAGE, end="")
