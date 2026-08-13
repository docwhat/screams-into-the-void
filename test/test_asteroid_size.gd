extends GdUnitTestSuite

var asteroid_size: AsteroidSize


func before() -> void:
	# Display the current seed.
	print("Current seed: %d" % Global.rng.seed)
	print("----------------------------------")


func before_test() -> void:
	# Create a test AsteroidSize instance with known parameters
	asteroid_size = AsteroidSize.new()
	asteroid_size.probability = 1.0
	asteroid_size.shape_radius = 20.0
	asteroid_size.shape_max_radius_delta = 5.0
	asteroid_size.shape_number_of_points = 4


func after_test() -> void:
	auto_free(asteroid_size)


func test_all_have_required_values() -> void:
	for size: AsteroidSize in AsteroidSize.sizes:
		assert_str(size.name).has_length(3, Comparator.GREATER_EQUAL)
		assert_float(size.shape_radius).is_greater(1.0)
		assert_float(size.shape_max_radius_delta).is_greater_equal(0.0)
		assert_int(size.shape_number_of_points).is_greater_equal(3)


func test_generate_polygon_returns_valid_number_of_points() -> void:
	var poly: PackedVector2Array = asteroid_size.generate_polygon()

	assert_int(poly.size()).is_equal(4)


func test_generate_polygon_first_point_at_radius() -> void:
	var first_point: Vector2 = asteroid_size.generate_polygon()[0]
	assert_float(first_point.x).is_equal_approx(asteroid_size.shape_radius, 0.001)
	assert_float(first_point.y).is_equal_approx(0.0, 0.001)


func test_generate_polygon_points_within_radius_bounds() -> void:
	var result: PackedVector2Array = asteroid_size.generate_polygon()
	var min_expected_radius: float = (
		asteroid_size.shape_radius - asteroid_size.shape_max_radius_delta
	)
	var max_expected_radius: float = (
		asteroid_size.shape_radius + asteroid_size.shape_max_radius_delta
	)

	for point: Vector2 in result:
		assert_float(point.length()).is_between(min_expected_radius, max_expected_radius)
