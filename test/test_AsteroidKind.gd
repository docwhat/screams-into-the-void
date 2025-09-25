class_name TestAsteroidKind extends GutTest

var asteroid_kind: AsteroidKind

func before_all():
  # Display the current seed.
  print("Current seed: %d" %Global.rng.seed)
  print("----------------------------------")

func before_each():
  # Create a test AsteroidKind instance with known parameters
  asteroid_kind = AsteroidKind.new()
  asteroid_kind.name = "TestTest"
  asteroid_kind.probability = 2.0

func after_each():
  autofree(asteroid_kind)
  
func test_all_have_required_values():
  for kind : AsteroidKind in AsteroidKind.kinds:
    assert_true(kind.name.length() >= 3, "Name should be longer than 3 characters for %s" % kind.resource_path)
