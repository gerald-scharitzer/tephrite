"""Build Conda packages from Mojo projects with rattler-build."""

from pathlib.path import Path
from python import Python

from .builder import Builder

alias DEFAULT_RECIPE = "."
alias DEFAULT_OUTPUT_DIR = "output"

struct RattlerBuilder(Builder):
	"""Build Conda packages from Mojo projects with rattler-build.

	Fields:
		recipe: Path to the recipe directory or file.
		output: Path to the output directory for Conda packages.
	"""

	var recipe: String
	var output: String

	fn __init__(inout self, recipe: String = DEFAULT_RECIPE, output: String = DEFAULT_OUTPUT_DIR):
		self.recipe = recipe
		self.output = output
	
	fn build(self) raises -> Path:
		"""Build Conda package from recipe directory into output directory."""
		recipe_path = Path(self.recipe)
		if not recipe_path.exists():
			raise Error("Recipe does not exist: " + self.recipe)
		
		output_path = Path(self.output)
		if output_path.exists():
			if not output_path.is_dir():
				raise Error("Output must be a directory: " + self.output)
		
		subprocess = Python.import_module("subprocess")
		command = Python.list()
		command.append("rattler-build")
		command.append("build")
		command.append("--no-include-recipe")
		command.append("-r")
		command.append(self.recipe)
		command.append("--output-dir")
		command.append(self.output)
		process = subprocess.run(command, capture_output=True, text=True)
		exit_code = int(process.returncode)
		if exit_code != 0:
			print(process.stdout)
			print(process.stderr)
			raise Error("rattler-build failed with exit code " + str(exit_code))
		return output_path # FIXME verify this
