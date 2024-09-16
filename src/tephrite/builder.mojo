"""Build Conda packages from Mojo projects."""

struct Builder:

	fn __init__(inout self):
		pass
	
	fn build(self):
		print("conda-build recipe") # TODO subprocess
