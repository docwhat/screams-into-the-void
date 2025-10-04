class_name TestAsteroidSize
extends GutTest

var asteroid_size: AsteroidSize


func before_all():
	# Display the current seed.
	print("Current seed: %d" % Global.rng.seed)
	print("----------------------------------")


func before_each():
	# Create a test AsteroidSize instance with known parameters
	asteroid_size = AsteroidSize.new()
	asteroid_size.probability = 1.0
	asteroid_size.shape_radius = 20.0
	asteroid_size.shape_max_radius_delta = 5.0
	asteroid_size.shape_number_of_points = 4


func after_each():
	autofree(asteroid_size)


func test_all_have_required_values():
	for size: AsteroidSize in AsteroidSize.sizes:
		assert_true(
			size.name.length() >= 3,
			"Name should be longer than 3 characters for %s" % size.resource_path,
		)
		assert_true(
			size.shape_radius > 1.0,
			"Shape radius should be greater than 0 for %s" % size.name,
		)
		assert_true(
			size.shape_max_radius_delta > 0.0,
			"Max radius delta should be non-negative for %s" % size.name,
		)
		assert_true(
			size.shape_number_of_points >= 3,
			"Number of points should be at least 3 for %s" % size.name,
		)


func test_generate_polygon_returns_packed_vector_2_array():
	var result = asteroid_size.generate_polygon()
	assert_true(result is PackedVector2Array, "generatePolygon should return a PackedVector2Array")


func test_generate_polygon_returns_valid_number_of_points():
	assert_eq(asteroid_size.generate_polygon().size(), 4)


func test_generate_polygon_first_point_at_radius():
	var first_point = asteroid_size.generate_polygon()[0]
	assert_almost_eq(
		first_point.x,
		asteroid_size.shape_radius,
		0.001,
		"First point x should be at radius",
	)
	assert_almost_eq(
		first_point.y,
		0.0,
		0.001,
		"First point y should be 0",
	)


func test_generate_polygon_points_within_radius_bounds():
	var result = asteroid_size.generate_polygon()
	var min_expected_radius = asteroid_size.shape_radius - asteroid_size.shape_max_radius_delta
	var max_expected_radius = asteroid_size.shape_radius + asteroid_size.shape_max_radius_delta

	for point in result:
		assert_between(point.length(), min_expected_radius, max_expected_radius)
