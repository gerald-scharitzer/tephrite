"""Build Conda packages from Mojo projects."""

from os import makedirs
from pathlib.path import Path
from python import Python

alias RECIPE = "recipe"
alias TARGET_CONDA = "target/conda"

struct Builder:

	fn __init__(inout self):
		pass
	
	fn build(self, recipe: String = RECIPE, output: String = TARGET_CONDA) raises -> Path:
		recipe_path = Path(recipe)
		if not recipe_path.exists():
			raise Error("Recipe directory does not exist: " + recipe)
		if not recipe_path.is_dir():
			raise Error("Recipe must be a directory: " + recipe)
		
		output_path = Path(output)
		if output_path.exists():
			if not output_path.is_dir():
				raise Error("Output must be a directory: " + output)
		else:
			makedirs(output_path, 0o755)
		
		subprocess = Python.import_module("subprocess")
		py_array = Python.list()
		py_array.append("conda-build")
		py_array.append("--output-folder")
		py_array.append(output)
		py_array.append(recipe)
		process = subprocess.run(py_array, capture_output=True, text=True)
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
