from testing import assert_equal

from tephrite import VERSION

fn test_it() raises:
    assert_equal(VERSION, "0.1.0")
