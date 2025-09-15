class_name TestAsteroidSize extends GutTest

var asteroid_size: AsteroidSize

func before_all():
  # Display the current seed.
  print("Current seed: %d" %Global.rng.seed)
  print("----------------------------------")

func before_each():
  # Create a test AsteroidSize instance with known parameters
  asteroid_size = AsteroidSize.new()
  asteroid_size.radius = 20.0
  asteroid_size.max_radius_delta = 5.0
  asteroid_size.number_of_points = 4
  asteroid_size.probability = 1.0

func after_each():
  autofree(asteroid_size)

func test_generatePolygon_returns_PackedVector2Array():
  var result = asteroid_size.generatePolygon()
  assert_true(result is PackedVector2Array, "generatePolygon should return a PackedVector2Array")

func test_generatePolygon_returns_valid_number_of_points():
  assert_eq(asteroid_size.generatePolygon().size(), 4)

func test_generatePolygon_first_point_at_radius():
  var first_point = asteroid_size.generatePolygon()[0]
  assert_almost_eq(first_point.x, asteroid_size.radius, 0.001, "First point x should be at radius")
  assert_almost_eq(first_point.y, 0.0, 0.001, "First point y should be 0")

func test_generatePolygon_points_within_radius_bounds():
  var result = asteroid_size.generatePolygon()
  var min_expected_radius = asteroid_size.radius - asteroid_size.max_radius_delta
  var max_expected_radius = asteroid_size.radius + asteroid_size.max_radius_delta

  for point in result:
    assert_between(point.length(), min_expected_radius, max_expected_radius)
