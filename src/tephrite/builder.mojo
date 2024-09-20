"""Build Conda packages from Mojo projects."""

from pathlib.path import Path
from python import Python

struct Builder:

	fn __init__(inout self):
		pass
	
	fn build(self, directory: String) raises -> Path:
		dirpath = Path(directory)
		if not dirpath.exists():
			raise Error("Directory does not exist: " + directory)
		if not dirpath.is_dir():
			raise Error("Not a directory: " + directory)
		
		subprocess = Python.import_module("subprocess")
		py_array = Python.list()
		py_array.append("conda-build")
		py_array.append(directory)
		process = subprocess.run(py_array, capture_output=True, text=True)
		exit_code = int(process.returncode)
		if exit_code != 0:
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
			raise Error("Package is not a file: " + path_string)
		return packpath
