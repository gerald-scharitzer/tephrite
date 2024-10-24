from testing import assert_equal

from tephrite import VERSION
from tephrite.conda import PLATFORM_NOARCH, TYPE_CONDA
from tephrite.recipe2 import Recipe2

fn test_it() raises:
	recipe = Recipe2()
	assert_equal(recipe.path, "recipe.yaml")
	
	meta = recipe.meta()
	assert_equal(meta.name, "tephrite")
	assert_equal(meta.version, VERSION)
	# TODO assert_equal(meta.build, "0")
	assert_equal(meta.platform, PLATFORM_NOARCH)
	assert_equal(meta.type, TYPE_CONDA)
