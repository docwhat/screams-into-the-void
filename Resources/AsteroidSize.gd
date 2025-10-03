class_name AsteroidSize extends Resource

# Used for sanity and debugging. Should be the name of the resource minus
# the suffix "AsteroidSize".
@export var name : String = "AsteroidSize"

# Used to calculate what the probability of an asteroid being spawned is.
@export var probability : float = 0.0

##########################
## Shape Values
@export_group("Shape", "shape_")

# Base radius of the asteroid.
@export_range(8.0, 100.0) var shape_radius : float = 8.0

# Maximum change to the radius of the asteroid.
@export_range(0.1, 20.0) var shape_max_radius_delta : float = 0.1

# The number of points for the polygon.
@export_range(3, 100, 1) var shape_number_of_points : int = 3

###########################
## Shader Values
@export_group("Shader", "shader_")

# The size of the noise patterns.
@export var shader_noise_size : float = 5.3

# The size of the craters.
@export var shader_crater_size : float = 0.2

# The ratio of pixels on the asteroid's surface.
@export var shader_pixels : float = 75.0

# This can be rebuilt by dragging from the FileSystem panel.
const RES_PATHS: Array[String] = [
		"res://Resources/AsteroidSize/BigAsteroidSize.tres",
		"res://Resources/AsteroidSize/GargantuanAsteroidSize.tres",
		"res://Resources/AsteroidSize/HugeAsteroidSize.tres",
		"res://Resources/AsteroidSize/LargeAsteroidSize.tres",
		"res://Resources/AsteroidSize/MediumAsteroidSize.tres",
		"res://Resources/AsteroidSize/SmallAsteroidSize.tres",
		"res://Resources/AsteroidSize/SpikySmallAsteroidSize.tres",
		"res://Resources/AsteroidSize/TinyAsteroidSize.tres",
  ]
static var sizes : Array[AsteroidSize]

# Load up the sizes array.
static func _static_init() -> void:
	for path : String in RES_PATHS:
		sizes.append(load(path))

# Select a random size resource.
static func random_size() -> AsteroidSize:
	var weights : PackedFloat32Array
	var random_index : int

	for size : AsteroidSize in sizes:
		weights.push_back(size.probability)

	random_index = Global.rng.rand_weighted(weights)
	return sizes[random_index]

# Given a shader, set the various knobs.
func configure_shader(mat : ShaderMaterial) -> void:
	mat.set_shader_parameter("pixels", shader_pixels)
	mat.set_shader_parameter("noise_size", shader_noise_size)
	mat.set_shader_parameter("crater_size", shader_crater_size)

# Generate a set of points describing an asteroid of this size.
func generatePolygon() -> PackedVector2Array:
	var polygon : PackedVector2Array

	# First point at the chosen radius.
	polygon.append(Vector2(shape_radius, 0))

	# The algorithm is to just go around a circle at evenly spaced points at random radii.
	for point in range(1, shape_number_of_points):
		# Randomize the radius.
		var rad : float = Global.rng.randf_range(
			shape_radius - Global.rng.randf_range(0.0, shape_max_radius_delta),
			shape_radius + Global.rng.randf_range(0.0, shape_max_radius_delta)
		)

		# calculate angle (evenly spaced).
		var angle : float = point * PI * 2 / shape_number_of_points
		polygon.append(Vector2(rad, 0).rotated(angle))

	return polygon

# EOF
