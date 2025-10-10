class_name Asteroid
extends RigidBody2D

static var count: int = 0

## Has this asteroid been made visible?
var debuted: bool = false

## The size of the asteroid.
@export var asteroid_size: AsteroidSize

## The kind of asteroid (e.g., Carbon, Ice, Organic, etc.)
@export var asteroid_kind: AsteroidKind

## How long it takes to dissolve an Asteroid (in seconds).
@export_range(0.1, 3.0, 0.1) var dissolve_duration: float = 2.0

## Save off the previous size, in case it changed.
var last_asteroid_size: AsteroidSize

## Save off the previous kind, in case it changed.
var last_asteroid_kind: AsteroidKind

## Used to dissolve an asteroid upon absorption.
var dissolve_tween: Tween

## The matter contained in this asteroid.
var matter_bag: MatterBag

## For making pretty pictures.
@onready var polygon_2d: Polygon2D = %Polygon2D

## For colliding.
@onready var collision_polygon_2d: CollisionPolygon2D = %CollisionPolygon2D

## The CanvasGroup that is wrapping the whole shebang.
@onready var dissolver: CanvasGroup = %Dissolver

# Deligation
var radius: float:
	get:
		return self.asteroid_size.shape_radius
var matter: Array[Matter]:
	get:
		return self.asteroid_kind.matter.keys()
var noise_size: float:
	get:
		return self.asteroid_size.shader_noise_size


func _init() -> void:
	asteroid_size = AsteroidSize.random_size()
	asteroid_kind = AsteroidKind.random_kind()


func _ready() -> void:
	rebuild()
	count += 1


func _process(_delta: float) -> void:
	if is_on_screen():
		if not debuted:
			debuted = true
	elif debuted:
		die()
		return


## Sets up the shape, size, color, etc.
func rebuild() -> void:
	if not is_valid():
		push_error("Asteroid.rebuild() called with invalid object.")
		return

	# Save these off, in case we need them.
	last_asteroid_kind = asteroid_kind
	last_asteroid_size = asteroid_size

	matter_bag = _random_matter()

	assert(radius > 0.0)
	# All asteroids start with a mass of 1_000.0 * radius.
	var calculated_mass: float = 1_000.0 * radius

	# Add the mass of the matter in the asteroid.
	for stuff: Matter in matter_bag.keys():
		calculated_mass += stuff.mass * matter_bag.get_by_matter(stuff)

	set_inertia(0) # Ensure it is set to be automatically calculated.
	set_mass(calculated_mass)

	if Global.debug_asteroid_launch:
		print_rich(
			"%s %s \n  m-r:    %f \n  m-m:    %f \n  i-r:    %f \n  i-m:    %f" % [
				asteroid_size.name,
				asteroid_kind.name,
				1_000.0 * radius,
				get_mass(),
				1_000_000.0 * radius,
				get_inertia(),
			],
		)

	# Image shape.
	var points = asteroid_size.generate_polygon()

	# Set the shapes.
	polygon_2d.set_polygon(points)
	polygon_2d.set_uv(points)
	collision_polygon_2d.set_polygon(points)

	# Texture Shader setup.
	var polymat = polygon_2d.material
	polymat.set_shader_parameter("seed", Global.rng.randf() * 1000 / 100.0)
	asteroid_size.configure_shader(polymat)
	asteroid_kind.configure_shader(polymat)


func is_valid() -> bool:
	return asteroid_size && asteroid_kind


## Contract method for Absorbers.
func be_absorbed() -> void:
	Events.emit_asteroid_hit(self)
	collision_polygon_2d.set_disabled.call_deferred(true)
	set_freeze_enabled.call_deferred(true)
	trigger_dissolve.call_deferred()
	count -= 1


## Animate the dissolution of the asteroid.
func trigger_dissolve() -> void:
	if dissolve_tween:
		return

	var dissolver_material: ShaderMaterial = \
	load("res://Shaders/dissolver-material.tres").duplicate()
	dissolver.set_material(dissolver_material)

	dissolver_material.set_shader_parameter("progress", 0.0)

	# Calculate the angle to the player.
	var player_angle: float = global_position.angle_to_point(Global.player_position)

	# Angle to the player.
	var angle: float = TAU * 3.0 / 4.0 - player_angle + TAU * 2.0 / 4.0

	# Compensate for any asteroid rotation.
	angle += rotation

	dissolver_material.set_shader_parameter("rotation", angle)

	# var size: Vector2 = calculate_polygon_bounds(polygon_2d.polygon)

	# Scaling is a number from 0.0 to 1.0 based on the radius of the asteroid.
	var scaling: float = (radius - 8) / (64.0 - 8.0)

	# TODO: The beam size should be based on the size of the asteroid.
	dissolver_material.set_shader_parameter("beam_size", min(0.1, 0.2 + 0.2 * scaling))
	# dissolver_material.set_shader_parameter("noise_density", noise_size + noise_size / scaling)

	# TODO: The duration should be based on the size of the asteroid.
	var duration: float = 0.15 + 4.0 * scaling

	# Give the big boys an extra boost.
	if scaling > 0.75:
		duration *= 4.0

	# TODO: Scoring should either be done after the dissolve, or be done
	# in parts during the dissolve as another Tween.
	dissolve_tween = create_tween()

	# IDEA: Alternate dissolve method: Move the asteroid towards the player as it dissolves.
	# Flip the dissolve so it moves from the player outward, giving the impression
	# that the asteroid is being sucked into the player.

	# Animate the dissolve.
	dissolve_tween.tween_property(
		dissolver_material,
		"shader_parameter/progress",
		1.0,
		duration,
	)

	# Die when dissolved.
	dissolve_tween.tween_callback(die)


## Buh-bye.
func die() -> void:
	count -= 1
	get_parent().remove_child(self)
	queue_free()


## check if the position is within the viewport
func is_on_screen() -> bool:
	var screen: Vector2 = get_viewport().size
	var pos: Vector2 = position # position
	var fudge: float = 64 * 4

	return pos.y >= 0.0 - fudge && \
	pos.x >= 0.0 - fudge && \
	pos.x <= screen.x + fudge && \
	pos.y <= screen.y + fudge


## Fling an asteroid at someone.
func launch(screen_size: Vector2, player_coord: Vector2) -> Node:
	var target_coord: Vector2
	var direction: float

	# Determine if this asteroid should intercept the player
	var should_intercept = Global.rng.randf() < Global.asteroid_player_intercept_chance

	if not is_valid():
		push_error(
			"This asteroid is invalid: name: %s   size: %s   kind: %s" % [
				name,
				asteroid_size,
				asteroid_kind,
			],
		)
		return

	# Need to freeze the asteroid prior to making changes.
	set_freeze_enabled(true)
	position = calculate_asteroid_starting_position(screen_size)

	if should_intercept:
		target_coord = player_coord
	else:
		target_coord = Vector2(
			Global.rng.randf_range(0, screen_size.x),
			Global.rng.randf_range(0, screen_size.y),
		)
	direction = position.angle_to_point(target_coord)

	# Choose a velocity
	var speed = Global.rng.randf_range(50.0, 180.0)
	var velocity = Vector2(speed, 0.0).rotated(direction)
	var torque: float = (Global.rng.randf() * get_mass() * max(1.0, get_inertia()))

	# Randomize direction of spin.
	if Global.rng.randi_range(0, 1) != 0:
		torque = 0 - torque

	# Restore the physics.
	set_freeze_enabled(false)

	# Start it spinning...
	apply_torque_impulse(torque)

	# ... and send it on its way.
	apply_impulse(velocity)

	if Global.debug_asteroid_launch:
		print_rich(
			"Launch: %s %s  ->  velocity: %s  torque: %f" % [
				asteroid_kind.name,
				asteroid_size.name,
				velocity,
				torque,
			],
		)

	return self


enum Side {
	TOP,
	LEFT,
	RIGHT,
	BOTTOM,
}


## Asteroids start off screen. We need to ensure they spawn far enough off screen
## that they can't be seen.
func calculate_asteroid_starting_position(screen_size: Vector2) -> Vector2:
	# Distance from edge of screen to the asteroid off screen.
	var spawn_margin: int = 100

	# Where the asteroid should spawn.
	var sides = [Side.TOP, Side.LEFT, Side.RIGHT, Side.BOTTOM]
	var side_weights: PackedFloat32Array = [5, 1.5, 1.5, 0.2]

	var side_index = Global.rng.rand_weighted(side_weights)
	match sides[side_index]:
		Side.LEFT:
			return Vector2(
				-spawn_margin,
				Global.rng.randf_range(0, screen_size.y),
			)
		Side.RIGHT:
			return Vector2(
				screen_size.x + spawn_margin,
				Global.rng.randf_range(0, screen_size.y),
			)
		Side.BOTTOM:
			return Vector2(
				Global.rng.randf_range(0, screen_size.x),
				screen_size.y + spawn_margin,
			)
		Side.TOP, _: # AKA Side.TOP
			return Vector2(
				Global.rng.randf_range(-spawn_margin, screen_size.x + spawn_margin),
				-spawn_margin,
			)


## Generate a random matter collection for this asteroid.
func _random_matter() -> MatterBag:
	var collection: MatterBag = MatterBag.new()
	var max_amount: float = radius / 8.0

	if Global.debug_asteroid_kind:
		print_rich("[b]== %s (%f) ==[/b]" % [asteroid_kind.name, radius])

	for m: Matter in matter:
		var amount: int = floor(max_amount * Global.rng.randf())
		collection.set_by_matter(m, amount)
		if Global.debug_asteroid_kind:
			print_rich("   %10s: %-5d" % [m.name, amount])

	return collection
