class_name Asteroid
extends RigidBody2D

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
@onready var line_2d: Line2D = %Line2D

## For colliding.
@onready var collision_polygon_2d: CollisionPolygon2D = %CollisionPolygon2D

## The CanvasGroup that is wrapping the whole shebang.
@onready var dissolver: CanvasGroup = %Dissolver

## Increase the size of pixels in the generated texture.
@export_range(1, 10, 1, "or_greater") var pixel_size: int = 3:
	get:
		return pixel_size
	set(value):
		if not polygon_2d:
			await ready
		polygon_2d.pixel_size = value
		line_2d.width = value * 2
		pixel_size = value

## The border color.
@export var border_color: Color = Color.BLACK:
	get:
		if not line_2d:
			await ready
		return line_2d.default_color
	set(value):
		if not line_2d:
			await ready
		line_2d.default_color = value

## The colors to use for different noise values.
@export var color_dark: Color = Color("#008800"):
	set(value):
		polygon_2d.color_dark = value
	get:
		if not polygon_2d:
			await ready
		return polygon_2d.color_dark
@export var color_mid: Color = Color("#00ff00"):
	set(value):
		polygon_2d.color_mid = value
	get:
		if not polygon_2d:
			await ready
		return polygon_2d.color_mid
@export var color_light: Color = Color("#88ff88"):
	set(value):
		polygon_2d.color_light = value
	get:
		if not polygon_2d:
			await ready
		return polygon_2d.color_light

@export_group("Noise", "noise_")

## The method for combining octaves into a fractal.
@export var noise_type: FastNoiseLite.NoiseType = FastNoiseLite.TYPE_SIMPLEX:
	get:
		return polygon_2d.noise_type
	set(value):
		if not polygon_2d:
			await ready
		polygon_2d.noise_type = value

## The frequency for all noise types. Low frequency results in smooth noise while
## high frequency results in rougher, more granular noise.
@export var noise_frequency: float = 0.024:
	get:
		return polygon_2d.noise_frequency
	set(value):
		if not polygon_2d:
			await ready
		polygon_2d.noise_frequency = value

## The number of noise layers that are sampled to get the final value for fractal noise types.
@export_range(0, 10, 1) var noise_fractal_octaves: int = 4:
	get:
		return polygon_2d.noise_fractal_octaves
	set(value):
		if not polygon_2d:
			await ready
		polygon_2d.noise_fractal_octaves = value

## Determines the strength of each subsequent layer of noise in fractal noise.
##
## A low value places more emphasis on the lower frequency base layers, while
## a high value puts more emphasis on the higher frequency layers.
@export var noise_fractal_gain: float = 0.18:
	get:
		return polygon_2d.noise_fractal_gain
	set(value):
		if not polygon_2d:
			await ready
		polygon_2d.noise_fractal_gain = value

## Frequency multiplier between subsequent octaves. Increasing this value results in higher
## octaves producing noise with finer details and a rougher appearance.
@export var noise_fractal_lacunarity: float = 25.0:
	get:
		return polygon_2d.noise_fractal_lacunarity
	set(value):
		if not polygon_2d:
			await ready
		polygon_2d.noise_fractal_lacunarity = value

# Deligation
var radius: float:
	get:
		return self.asteroid_size.shape_radius
var matter: Array[Matter]:
	get:
		return self.asteroid_kind.matter.keys()
# var noise_size: float:
# 	get:
# 		return self.asteroid_size.shader_noise_size


func _init() -> void:
	asteroid_size = AsteroidSize.random_size()
	asteroid_kind = AsteroidKind.random_kind()


func _ready() -> void:
	rebuild()
	Global.increment_asteroid_count()


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

	# All asteroids start with a mass of 1_000.0 * radius.
	var calculated_mass: float = 1_000.0 * radius

	# Add the mass of the matter in the asteroid.
	for stuff: Matter in matter_bag.keys():
		calculated_mass += stuff.mass * matter_bag.get_by_matter(stuff)

	set_inertia(0) # Ensure it is set to be automatically calculated.
	set_mass(calculated_mass)

	# Set the physics material.
	var physics: PhysicsMaterial = PhysicsMaterial.new()
	physics.friction = 0.0
	physics.bounce = 0.5
	# TODO: This should be based on the asteroid kind.
	if Global.flip_coin():
		physics.absorbent = true

	physics_material_override = physics

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
	polygon_2d.colors = asteroid_kind.palette()
	polygon_2d.update_texture()
	#polygon_2d.set_uv(points)

	line_2d.set_points(points)
	collision_polygon_2d.set_polygon(points)


func is_valid() -> bool:
	return asteroid_size && asteroid_kind


## Contract method for Absorbers.
func be_absorbed() -> void:
	Events.emit_asteroid_hit(self)
	collision_polygon_2d.set_disabled.call_deferred(true)
	set_freeze_enabled.call_deferred(true)
	trigger_dissolve.call_deferred()


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
	get_parent().remove_child(self)
	queue_free()
	Global.decrement_asteroid_count()


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
func launch() -> Node:
	var screen_size: Vector2 = Global.play_field.get_viewport().get_visible_rect().size
	var player_coord: Vector2 = Global.player_node.global_position
	# TODO: Don't launch if there are too many asteroids on screen.
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
	var speed = Global.rng.randf_range(10.0, 180.0)
	var velocity = Vector2(speed * get_mass(), 0.0).rotated(direction)

	# Brute-force angular velocity for now. See comment below.
	angular_velocity = Global.rng.randf_range(0 - TAU / 4.0, TAU / 4.0)
	if Global.rng.randf() < 0.25:
		angular_velocity *= 2.0

	# Restore the physics.
	set_freeze_enabled(false)

	# Wait a frame to ensure the physics are restored.
	await Engine.get_main_loop().process_frame

	# Send it on its way!
	apply_impulse(velocity)
	# Note: I've been unable to get apply_impulse to work correctly.
	# Instead, I'm brute-forcing the velocity while it is frozen.
	# apply_torque_impulse(torque)

	if Global.debug_asteroid_launch:
		print_rich(
			"Launch: %s %s  ->  linear_velocity: %s  angular_velocity: %f" % [
				asteroid_kind.name,
				asteroid_size.name,
				linear_velocity,
				angular_velocity,
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
