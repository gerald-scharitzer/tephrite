"""Conda packages"""

from pathlib.path import Path

struct Meta:
	"""Wrap Conda package metadata."""

	var name: String
	var version: String
	var build: String
	var platform: String
	var type: String

	fn __init__(inout self, name: String, version: String, build: String = "0", platform: String = "noarch", type: String = "tar.bz2"):
		self.name = name
		self.version = version
		self.build = build
		self.platform = platform
		self.type = type
	
	fn path(self) -> Path:
		"""Get package path."""
		return Path(self.platform + "/" + self.name + "-" + self.version + "-" + self.build + "." + self.type)
