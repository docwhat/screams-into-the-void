class_name AsteroidSize
extends Resource

## Used for sanity and debugging. Should be the name of the resource minus
## the suffix "AsteroidSize".
@export var name: String = "AsteroidSize"

## Used to calculate what the probability of an asteroid being spawned is.
@export var probability: float = 0.0

##########################
## Shape Values
@export_group("Shape", "shape_")

## Base radius of the asteroid.
@export_range(8.0, 100.0) var shape_radius: float = 8.0

## Maximum change to the radius of the asteroid.
@export_range(0.1, 20.0) var shape_max_radius_delta: float = 0.1

## The number of points for the polygon.
@export_range(3, 100, 1) var shape_number_of_points: int = 3

static var sizes: Array[AsteroidSize]


## Load the AsteroidSize resources dynamically from disk.
static func load_resources() -> Array[AsteroidSize]:
	var resources: Array[AsteroidSize] = []
	var file_paths: Array[String] = ResourceTools.find_resources("res://asteroid_size")

	for file_path: String in file_paths:
		var res: AsteroidSize = load(file_path)
		if res:
			resources.append(res)
		else:
			push_error("Failed to load AsteroidSize resource from %s" % [file_path])

	return resources


## Load up the sizes array.
static func _static_init() -> void:
	sizes = load_resources()


## Select a random size resource.
static func random_size() -> AsteroidSize:
	var size_weights: PackedFloat32Array = []
	var random_index: int

	for size: AsteroidSize in sizes:
		size_weights.push_back(size.probability)

	random_index = Global.rng.rand_weighted(size_weights)
	return sizes[random_index]


## Generate a set of points describing an asteroid of this size.
func generate_polygon() -> PackedVector2Array:
	var polygon: PackedVector2Array

	# First point at the chosen radius.
	polygon.append(Vector2(shape_radius, 0))

	# The algorithm is to just go around a circle at evenly spaced points at random radii.
	for point: int in range(1, shape_number_of_points):
		# Randomize the radius.
		var rad: float = Global.rng.randf_range(
			shape_radius - Global.rng.randf_range(0.0, shape_max_radius_delta),
			shape_radius + Global.rng.randf_range(0.0, shape_max_radius_delta),
		)

		# calculate angle (evenly spaced).
		var angle: float = point * PI * 2 / shape_number_of_points
		polygon.append(Vector2(rad, 0).rotated(angle))

	return polygon

# EOF
