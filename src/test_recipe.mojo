from testing import assert_equal

from tephrite.builder import DEFAULT_RECIPE_DIR
from tephrite.recipe import Recipe

fn test_it() raises:
	recipe = Recipe(DEFAULT_RECIPE_DIR)
	assert_equal(recipe.directory, "recipe")
