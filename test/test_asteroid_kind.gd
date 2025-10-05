extends GdUnitTestSuite

var asteroid_kind: AsteroidKind


func before():
	# Display the current seed.
	print("Current seed: %d" % Global.rng.seed)
	print("----------------------------------")


func before_test():
	# Create a test AsteroidKind instance with known parameters
	asteroid_kind = AsteroidKind.new()
	asteroid_kind.name = "TestTest"
	asteroid_kind.probability = 2.0


func after_test():
	auto_free(asteroid_kind)


func test_all_have_required_values():
	for kind: AsteroidKind in AsteroidKind.kinds:
		assert_str(kind.name).has_length(3, Comparator.GREATER_EQUAL)
