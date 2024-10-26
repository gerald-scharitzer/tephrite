"""anaconda.org Conda package repository

Run the `anaconda` command line tool to call anaconda.org.
"""

from pathlib.path import Path
from python import Python

from .rattler_builder import DEFAULT_RECIPE, DEFAULT_OUTPUT_DIR
from .recipe2 import Recipe2

fn is_logged_in() raises -> Bool:
	"""Check if user is logged in.
	
	`anaconda whoami` writes to stderr and returns

	```
	Using Anaconda API: <url>
	Username: <user>
	Member since: <datetime>
	  +user_type: <type>
	```
	
	if logged in and


	```
	Using Anaconda API: <url>
	Anonymous User
	```

	if logged out.
	"""
	subprocess = Python.import_module("subprocess")
	command = Python.list()
	command.append("anaconda")
	command.append("whoami")
	process = subprocess.run(command, capture_output=True, text=True)
	exit_code = int(process.returncode)
	if exit_code != 0:
		print(process.stdout)
		print(process.stderr)
		raise Error(str(command) + " failed with exit code " + str(exit_code))
	stderr = str(process.stderr)
	lines = stderr.splitlines()
	for line in lines:
		if line[].startswith("Username: "):
			return True
	return False

fn upload() raises:
	"""Upload the Conda package specified in the recipe for the builder."""
	recipe = Recipe2()
	meta = recipe.meta()
	path = Path(DEFAULT_OUTPUT_DIR) / meta.path()
	upload(str(path))

fn upload(pathname: String) raises:
	"""Upload the Conda package at the specified path."""
	path = Path(pathname)
	if not path.exists():
		raise Error("Package does not exist: " + pathname)
	if not is_logged_in():
		raise Error("Not logged in to anaconda.org")
	subprocess = Python.import_module("subprocess")
	command = Python.list()
	command.append("anaconda")
	command.append("upload")
	command.append(pathname)
	process = subprocess.run(command, capture_output=True, text=True)
	exit_code = int(process.returncode)
	if exit_code != 0:
		print(process.stdout)
		print(process.stderr)
		raise Error(str(command) + " failed with exit code " + str(exit_code))
