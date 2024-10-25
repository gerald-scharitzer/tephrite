"""Conda package repository"""

from pathlib.path import Path
from python import Python

trait CondaRepository:

	fn upload(self) raises:
		"""Upload the Conda package specified in the recipe for the builder."""
		...

	fn upload(self, package: String) raises:
		"""Upload the Conda package at the specified path."""
		...
