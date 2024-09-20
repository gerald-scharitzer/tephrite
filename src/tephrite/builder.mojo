"""Build Conda packages from Mojo projects."""

from pathlib.path import Path
from python import Python

struct Builder:

	fn __init__(inout self):
		pass
	
	fn build(self, directory: String) raises:
		dirpath = Path(directory)
		if not dirpath.exists():
			raise Error("Directory does not exist: " + directory)
		if not dirpath.is_dir():
			raise Error("Not a directory: " + directory)
		
		subprocess = Python.import_module("subprocess")
		py_array = Python.list()
		py_array.append("conda-build")
		py_array.append(directory)
		process = subprocess.run(py_array)
		exit_code = int(process.returncode)
		if exit_code != 0:
			raise Error("conda-build failed with exit code " + str(exit_code))
