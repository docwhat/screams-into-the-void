class_name AsteroidSize

# The various asteroid sizes.
# Arguments:
# - radius
# - amount of variation allowed to for the radius
# - the number of points for the polygon
# - weighted probability of the asteroid appearing
static var TinyAsteroidSize
static var SmallAsteroidSize
static var SpikySmallAsteroidSize
static var MediumAsteroidSize
static var BigAsteroidSize
static var LargeAsteroidSize
static var HugeAsteroidSize
static var GargantuanAsteroidSize

static func _static_init():
  # new(radius, max_radius_delta, poly_points, probability)
  TinyAsteroidSize = AsteroidSize.new(8, 3.0, 6, 1.0)
  ALL_SIZES.push_back(TinyAsteroidSize)

  SmallAsteroidSize = AsteroidSize.new(12, 4.5, 7, 2.0)
  ALL_SIZES.push_back(SmallAsteroidSize)

  SpikySmallAsteroidSize = AsteroidSize.new(12, 10.0, 6, 1.5)
  ALL_SIZES.push_back(SpikySmallAsteroidSize)

  MediumAsteroidSize = AsteroidSize.new(16, 6.4, 10, 2.5)
  ALL_SIZES.push_back(MediumAsteroidSize)

  BigAsteroidSize = AsteroidSize.new(28, 12.0, 14, 5.0)
  ALL_SIZES.push_back(BigAsteroidSize)

  LargeAsteroidSize = AsteroidSize.new(32, 10.0, 18, 2.0)
  ALL_SIZES.push_back(LargeAsteroidSize)

  HugeAsteroidSize = AsteroidSize.new(42, 5.0, 25, 0.2)
  ALL_SIZES.push_back(HugeAsteroidSize)

  GargantuanAsteroidSize = AsteroidSize.new(64, 4.0, 40, 0.1)
  ALL_SIZES.push_back(GargantuanAsteroidSize)

# Base radius of the asteroid.
var radius : float

# Maximum change to the radius of the asteroid.
var max_radius_delta : float

# Used to calculate what the probability of an asteroid being spawned is.
var probability : float

# The number of points for the polygon.
var number_of_points : int

# Stores all asteroid sizes.
static var ALL_SIZES : Array[AsteroidSize] = []

# Retrieve a random asteroid size.
static func get_random_asteroid_size() -> AsteroidSize:
  var weights : PackedFloat32Array

  for size in ALL_SIZES:
    weights.push_back(size.probability)

  var random_index = Global.rng.rand_weighted(weights)
  return ALL_SIZES[random_index]

func _init(r : float, d : float, n: int, p: float) -> void:
    radius = r
    max_radius_delta = d
    number_of_points = n
    probability = p

# Generate a set of points describing an asteroid of this size.
func generatePolygon() -> PackedVector2Array:
  var polygon : PackedVector2Array
  # First point at the chosen radius.
  polygon.append(Vector2(radius, 0))

  # The algorithm is to just go around a circle at evenly spaced points at random radii.
  for point in range(1, number_of_points):
    # Randomize the radius.
    var rad : float = Global.rng.randf_range(
      radius - Global.rng.randf_range(0.0, max_radius_delta),
      radius + Global.rng.randf_range(0.0, max_radius_delta)
    )

    # calculate angle (evenly spaced).
    var angle : float = point * PI * 2 / number_of_points
    polygon.append(Vector2(rad, 0).rotated(angle))

  return polygon
