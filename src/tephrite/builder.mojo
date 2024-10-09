"""Build Conda packages from Mojo projects."""

from os import makedirs
from pathlib.path import Path
from python import Python

alias DEFAULT_RECIPE_DIR = "recipe"
alias DEFAULT_OUTPUT_DIR = "target/conda"

struct Builder:
	"""Build Conda packages from Mojo projects.

	Fields:
		output: Path to the output directory for Conda packages.
	"""

	var output: String

	fn __init__(inout self, output: String = DEFAULT_OUTPUT_DIR):
		self.output = output
	
	fn build(self, recipe: String = DEFAULT_RECIPE_DIR) raises -> Path:
		"""Build Conda package from recipe directory into output directory."""
		recipe_path = Path(recipe)
		if not recipe_path.exists():
			raise Error("Recipe directory does not exist: " + recipe)
		if not recipe_path.is_dir():
			raise Error("Recipe must be a directory: " + recipe)
		
		output_path = Path(self.output)
		if output_path.exists():
			if not output_path.is_dir():
				raise Error("Output must be a directory: " + self.output)
		else:
			makedirs(output_path, 0o755)
		
		subprocess = Python.import_module("subprocess")
		command = Python.list()
		command.append("conda-build")
		command.append("--output-folder")
		command.append(self.output)
		command.append(recipe)
		process = subprocess.run(command, capture_output=True, text=True)
		exit_code = int(process.returncode)
		if exit_code != 0:
			print(process.stdout)
			print(process.stderr)
			raise Error("conda-build failed with exit code " + str(exit_code))
		
		stdout = str(process.stdout) # TODO read stdout from pipe
		lines = stdout.split("\n")
		capture_upload = True
		path_string = str("")
		for line in lines:
			if capture_upload:
				if line[].startswith("anaconda upload \\"):
					capture_upload = False
			else:
				path_string = line[].strip()
				break
		
		if len(path_string) == 0:
			raise Error("No package path found in conda-build output")
		packpath = Path(path_string)
		if not packpath.exists():
			raise Error("Package file does not exist: " + path_string)
		if not packpath.is_file():
			raise Error("Package must be a file: " + path_string)
		return packpath
