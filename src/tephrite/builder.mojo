"""Build Conda packages from Mojo projects."""

from pathlib.path import Path

trait Builder:
	"""Build Conda packages from Mojo projects."""

	fn build(self) raises -> Path:
		"""Build Conda package from recipe directory into output directory.

		Arguments:
			recipe: Path to the recipe directory
		
		Returns:
			Path to the built Conda package file.
		"""
		...
