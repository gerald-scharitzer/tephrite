from testing import assert_equal

from tephrite.builder import Builder

fn test_it() raises:
	builder = Builder()
	assert_equal(builder.output, "target/conda")
