"""Conda recipe"""

from pathlib.path import Path
from python import Python

struct Recipe:

	var directory: String

	fn __init__(inout self, directory: String):
		self.directory = directory
		pass
	
	fn meta(self) raises:
		meta_path = Path(self.directory) / "meta.yaml"
		if not meta_path.exists():
			raise Error("meta.yaml not found in " + self.directory)
		if not meta_path.is_file():
			raise Error("meta.yaml is not a file in " + self.directory)
		
		meta_yaml = meta_path.read_text() # FIXME stream instead of loading everything in memory
		yaml = Python.import_module("yaml")
		py_meta = yaml.safe_load(meta_yaml)
		package_name = str(py_meta["package"]["name"])
		package_version = str(py_meta["package"]["version"])
		py_build = py_meta["build"]
		py_build_number = py_build.get("number")
		print("build number", str(py_build_number))
		# TODO get build number with default to 0
		print("package", package_name)
		print("version", package_version)
