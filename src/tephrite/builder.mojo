"""Build Conda packages from Mojo projects."""

from python import Python

struct Builder:

	fn __init__(inout self):
		pass
	
	fn build(self) raises:
		subprocess = Python.import_module("subprocess")
		process = subprocess.run(["conda-build", "recipe"])
		exit_code = int(process.returncode)
		if exit_code != 0:
			raise Error("conda-build failed with exit code " + str(exit_code))
