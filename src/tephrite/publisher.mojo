"""Publish Conda packages to anaconda.org"""

from pathlib.path import Path
from python import Python

struct Publisher:

    fn __init__(inout self):
        pass
    
    fn publish(self, package: String) raises:
        # TODO check package path
        subprocess = Python.import_module("subprocess")
        command = Python.list()
        command.append("anaconda")
        command.append("upload")
        command.append(package)
        process = subprocess.run(command, capture_output=True, text=True)
        exit_code = int(process.returncode)
        if exit_code != 0:
            print(process.stdout)
            print(process.stderr)
            raise Error("anaconda upload failed with exit code " + str(exit_code))
