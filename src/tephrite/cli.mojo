"""Command line interface"""

from tephrite import VERSION
from .conda_builder import CondaBuilder
from .publisher import Publisher
from .rattler_builder import RattlerBuilder

alias USAGE = """\
Usage: tephrite [command [objects...]]
Commands:

	b | build [<dir>]
		Build a Conda package from the recipe in directory <dir>.
		If <dir> is not specified, then the directory `recipe` is used.
	
	p | publish
		Publish a Conda package built from the recipe.
	
	v | version
		Print the version of this package.
"""

alias EXIT_SUCCESS = 0
alias EXIT_FAILURE = 1
alias EXIT_INFO = 2

fn run(args: VariadicList[StringRef]) raises -> Int:
	"""Process command line arguments and return exit code."""

	alias ARG_STATE_START = 0
	alias ARG_STATE_COMMAND = 1
	alias ARG_STATE_BUILD = 2
	alias ARG_STATE_CONDA_BUILD = 3

	if len(args) < 2:
		print_usage()
		return EXIT_INFO

	argx = 0
	arg_state = ARG_STATE_START
	has_objects = False
	for arg in args: # simple state machine TODO simplify to varying number of arguments
		if arg_state == ARG_STATE_START: # do nothing with the command name
			arg_state = ARG_STATE_COMMAND
		elif arg_state == ARG_STATE_COMMAND: # options or command
			if arg == "b" or arg == "build":
				arg_state = ARG_STATE_BUILD
			elif arg == "cb" or arg == "conda-build":
				arg_state = ARG_STATE_CONDA_BUILD
			elif arg == "p" or arg == "publish":
				publisher = Publisher()
				publisher.publish()
				return EXIT_SUCCESS
			elif arg == "v" or arg == "version":
				print(VERSION)
				return EXIT_SUCCESS
			else:
				print_usage()
				return EXIT_FAILURE
		elif arg_state == ARG_STATE_BUILD: # build package with rattler
			has_objects = True
			default_builder = RattlerBuilder() # TODO handle build hash
			default_builder.recipe = arg
			_ = default_builder.build() # TODO handle package path
		elif arg_state == ARG_STATE_CONDA_BUILD: # build package with conda
			has_objects = True
			builder = CondaBuilder()
			_ = builder.build(arg) # TODO handle package path
		else: # argument state
			raise Error("ERROR invalid argument state " + str(arg_state) + " at index " + str(argx)) # TODO proper error message
		argx += 1

	if not has_objects: # run command with defaults
		if arg_state == ARG_STATE_BUILD: # build default recipe
			default_builder = RattlerBuilder()
			_ = default_builder.build() # TODO handle package path
		elif arg_state == ARG_STATE_CONDA_BUILD: # build package with conda
			builder = CondaBuilder()
			_ = builder.build() # TODO handle package path
		else: # argument state
			raise Error("ERROR invalid argument state " + str(arg_state) + " at index " + str(argx)) # TODO proper error message
	
	return EXIT_SUCCESS

fn print_usage():
	"""Print the usage string to standard output."""
	print(USAGE, end="")
