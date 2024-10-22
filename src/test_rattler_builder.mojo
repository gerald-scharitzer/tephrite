from testing import assert_equal

from tephrite.rattler_builder import RattlerBuilder

fn test_it() raises:
	builder = RattlerBuilder()
	assert_equal(builder.output, "output")
