"""Publish Conda packages to anaconda.org"""

from pathlib.path import Path
from python import Python

from .anaconda import is_logged_in
from .recipe import Recipe

struct Publisher:

    fn __init__(inout self):
        pass
    
    fn publish(self) raises:
        """Publish the Conda package specified in the recipe."""
        recipe = Recipe("recipe")
        meta = recipe.meta()
        path = Path("target/conda") / meta.path()
        self.publish(str(path))

    fn publish(self, package: String) raises:
        """Publish the Conda package at the specified path."""
        # TODO check package path
        if not is_logged_in():
            raise Error("Not logged in to anaconda.org")
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
