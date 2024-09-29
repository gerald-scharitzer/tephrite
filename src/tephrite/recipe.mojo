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
        
        yaml = Python.import_module("yaml")
        py_meta = yaml.safe_load(str(meta_path))
        package_name = str(py_meta.package.name)
        print("package", package_name)
    