from testing import assert_equal

from tephrite.recipe2 import Recipe2

fn test_it() raises:
	recipe = Recipe2()
	assert_equal(recipe.path, "recipe.yaml")
