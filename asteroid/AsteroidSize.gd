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

# Stores all asteroid sizes.
static var ALL_SIZES : Array[AsteroidSize] = []

static func _static_init():
  ##############################################
  TinyAsteroidSize = AsteroidSize.new()
  TinyAsteroidSize.radius = 8
  TinyAsteroidSize.max_radius_delta = 3.0
  TinyAsteroidSize.number_of_points = 6
  TinyAsteroidSize.probability = 1.0

  # Shader parameters
  TinyAsteroidSize.noise_size = 20.0
  TinyAsteroidSize.crater_size = 0.2
  ALL_SIZES.push_back(TinyAsteroidSize)

  ##############################################
  SmallAsteroidSize = AsteroidSize.new()
  SmallAsteroidSize.radius = 12
  SmallAsteroidSize.max_radius_delta = 4.5
  SmallAsteroidSize.number_of_points = 7
  SmallAsteroidSize.probability = 2.0

  # Shader parameters
  SmallAsteroidSize.noise_size = 18.0
  SmallAsteroidSize.crater_size = 0.2
  ALL_SIZES.push_back(SmallAsteroidSize)

  ##############################################
  SpikySmallAsteroidSize = AsteroidSize.new()
  SpikySmallAsteroidSize.radius = 12
  SpikySmallAsteroidSize.max_radius_delta = 10.0
  SpikySmallAsteroidSize.number_of_points = 8
  SpikySmallAsteroidSize.probability = 1.5

  # Shader parameters
  SpikySmallAsteroidSize.noise_size = 18.0
  SpikySmallAsteroidSize.crater_size = 0.2
  ALL_SIZES.push_back(SpikySmallAsteroidSize)

  ##############################################
  MediumAsteroidSize = AsteroidSize.new()
  MediumAsteroidSize.radius = 16
  MediumAsteroidSize.max_radius_delta = 7.4
  MediumAsteroidSize.number_of_points = 11
  MediumAsteroidSize.probability = 2.5

  # Shader parameters
  MediumAsteroidSize.pixels = 75.0
  MediumAsteroidSize.noise_size = 10.0
  MediumAsteroidSize.crater_size = 0.25
  ALL_SIZES.push_back(MediumAsteroidSize)

  ##############################################
  BigAsteroidSize = AsteroidSize.new()
  BigAsteroidSize.radius = 28
  BigAsteroidSize.max_radius_delta = 11.0
  BigAsteroidSize.number_of_points = 17
  BigAsteroidSize.probability = 5.0

  # Shader parameters
  BigAsteroidSize.noise_size = 6.3
  BigAsteroidSize.crater_size = 0.3
  ALL_SIZES.push_back(BigAsteroidSize)

  ##############################################
  LargeAsteroidSize = AsteroidSize.new()
  LargeAsteroidSize.radius = 32
  LargeAsteroidSize.max_radius_delta = 10.0
  LargeAsteroidSize.number_of_points = 19
  LargeAsteroidSize.probability = 2.0

  # Shader parameters
  LargeAsteroidSize.noise_size = 5.3
  LargeAsteroidSize.crater_size = 0.35
  ALL_SIZES.push_back(LargeAsteroidSize)

  ##############################################
  HugeAsteroidSize = AsteroidSize.new()
  HugeAsteroidSize.radius = 42
  HugeAsteroidSize.max_radius_delta = 7.0
  HugeAsteroidSize.number_of_points = 25
  HugeAsteroidSize.probability = 0.2

  # Shader parameters
  HugeAsteroidSize.noise_size = 5.3
  HugeAsteroidSize.crater_size = 0.3
  ALL_SIZES.push_back(HugeAsteroidSize)

  ##############################################
  GargantuanAsteroidSize = AsteroidSize.new()
  GargantuanAsteroidSize.radius = 64
  GargantuanAsteroidSize.max_radius_delta = 5.0
  GargantuanAsteroidSize.number_of_points = 40
  GargantuanAsteroidSize.probability = 0.1

  # Shader parameters
  GargantuanAsteroidSize.noise_size = 5.3
  GargantuanAsteroidSize.crater_size = 0.3
  ALL_SIZES.push_back(GargantuanAsteroidSize)

# Base radius of the asteroid.
var radius : float = 10

# Maximum change to the radius of the asteroid.
var max_radius_delta : float  = 3

# Used to calculate what the probability of an asteroid being spawned is.
var probability : float = 0.1

# The number of points for the polygon.
var number_of_points : int

# The ratio of pixels on the asteroid's surface.
var pixels : float = 75.0

# The size of the noise patterns.
var noise_size : float = 5.3

# The size of the craters.
var crater_size : float = 0.3

# Retrieve a random asteroid size.
static func random_size() -> AsteroidSize:
  var weights : PackedFloat32Array

  for size in ALL_SIZES:
    weights.push_back(size.probability)

  var random_index = Global.rng.rand_weighted(weights)
  return ALL_SIZES[random_index]

func configure_shader(mat : ShaderMaterial) -> void:
  mat.set_shader_parameter("pixels", pixels)
  mat.set_shader_parameter("noise_size", noise_size)
  mat.set_shader_parameter("crater_size", crater_size)

  if Global.debug_asteroid_size:
    print_rich("r: %.0f +/- %.1f \t n: %d \t pix: %.2f \t noise: %.2f \t crater: %.2f" % [
      radius,
      max_radius_delta,
      number_of_points,
      pixels,
      noise_size,
      crater_size
    ])
    print_rich("  n/r: %.2f  d/r: %.2f  noise/r: %.2f  crater/r: %.3f  crater/noise: %.3f" % [
      number_of_points / radius,
      max_radius_delta / radius,
      noise_size / radius,
      crater_size / radius,
      crater_size / noise_size
    ])

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
