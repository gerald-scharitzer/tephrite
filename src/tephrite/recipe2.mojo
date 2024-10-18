"""Conda recipe version 2

https://prefix-dev.github.io/rattler-build/latest/reference/recipe_file/
"""

from pathlib.path import Path
from python import Python

from .conda import Meta, PLATFORM_NOARCH

struct Recipe2:

	var path: String

	fn __init__(inout self, path: String):
		self.path = path
	
	fn meta(self) raises -> Meta:
		"""Get package metadata from recipe.

		The build depends on the build number and the build string.
		If the string is specified, then it overrides the number.

		| number | string | build |
		| ------ | ------ | ----- |
		|        |        | 0     |
		| n      |        | n     |
		|        | s      | s     |
		| n      | s      | s     |
		"""
		meta_path = Path(self.path)
		if not meta_path.exists():
			raise Error("Recipe not found: " + str(meta_path))
		if meta_path.is_dir():
			meta_path = Path(self.path) / "recipe.yaml"
		if not meta_path.is_file():
			raise Error("Recipe must be a file: " + str(meta_path))
		
		meta_yaml = meta_path.read_text() # FIXME stream instead of loading everything in memory
		yaml = Python.import_module("yaml")
		py_meta = yaml.safe_load(meta_yaml)
		package_name = str(py_meta["package"]["name"])
		package_version = str(py_meta["package"]["version"])
		py_build = py_meta["build"] # TODO handle python KeyError

		py_build_noarch = py_build.get(PLATFORM_NOARCH)
		if py_build_noarch is None:
			platform = str("TODO") # TODO handle arch and OS
		else:
			platform = PLATFORM_NOARCH

		py_build_number = py_build.get("number")
		if py_build_number is None:
			build_number = str("0")
		else:
			build_number = str(py_build_number)
		
		py_build_string = py_build.get("string")
		if py_build_string is None:
			build_string = str("")
		else:
			build_string = str(py_build_string)
		
		if len(build_string) == 0:
			build = build_number
		else:
			build = build_string

		return Meta(package_name, package_version, build, platform) # TODO handle .conda