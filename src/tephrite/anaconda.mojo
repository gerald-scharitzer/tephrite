"""anaconda.org Conda package repository"""

from python import Python

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
