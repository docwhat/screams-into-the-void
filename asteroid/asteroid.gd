class_name Asteroid
extends RigidBody2D

## Has this asteroid been made visible?
var debuted: bool = false

## The size of the asteroid.
@export var asteroid_size: AsteroidSize

## The kind of asteroid (e.g., Carbon, Ice, Organic, etc.)
@export var asteroid_kind: FlotsamComposition

## How long it takes to dissolve an Asteroid (in seconds).
@export_range(0.1, 3.0, 0.1) var dissolve_duration: float = 2.0

## Save off the previous size, in case it changed.
var last_asteroid_size: AsteroidSize

## Save off the previous kind, in case it changed.
var last_asteroid_kind: FlotsamComposition

## Used to dissolve an asteroid upon absorption.
var dissolve_tween: Tween

## The matter contained in this asteroid.
var matter_bag: MatterBag

## Has the asteroid been marked for absorbtion?
var is_marked_for_absorbtion: bool

@onready var shape: Polygon2D = %Shape
@onready var outline: Line2D = %Outline
@onready var collision_shape: CollisionPolygon2D = %CollisionShape

## Increase the size of pixels in the generated texture.
@export_range(1, 10, 1, "or_greater") var pixel_size: int = 3:
	get:
		return pixel_size
	set(value):
		if not shape:
			await ready
		shape.pixel_size = value
		outline.width = value
		pixel_size = value

## The border color.
@export var border_color: Color = Color.LAWN_GREEN:
	get:
		return await _outline_get(&"default_color")
	set(value):
		_outline_set(&"default_color", value)

## The dark shade used in the noise/dithering.
@export var color_dark: Color = Color("#008800"):
	get:
		return await _shape_get(&"color_dark")
	set(value):
		_shape_set(&"color_dark", value)

@export var color_mid: Color = Color("#00ff00"):
	get:
		return await _shape_get(&"color_mid")
	set(value):
		_shape_set(&"color_mid", value)

@export var color_light: Color = Color("#88ff88"):
	get:
		return await _shape_get(&"color_light")
	set(value):
		_shape_set(&"color_light", value)

@export_group("Noise", "noise_")

## The method for combining octaves into a fractal.
@export var noise_type: FastNoiseLite.NoiseType = FastNoiseLite.TYPE_SIMPLEX:
	get:
		return await _shape_get(&"noise_type")
	set(value):
		_shape_set(&"noise_type", value)

## The frequency for all noise types. Low frequency results in smooth noise while
## high frequency results in rougher, more granular noise.
@export var noise_frequency: float = 0.03:
	get:
		return await _shape_get(&"noise_frequency")
	set(value):
		_shape_set(&"noise_frequency", value)

## The number of noise layers that are sampled to get the final value for fractal noise types.
@export_range(0, 10, 1) var noise_fractal_octaves: int = 4:
	get:
		return await _shape_get(&"noise_fractal_octaves")
	set(value):
		_shape_set(&"noise_fractal_octaves", value)

## Determines the strength of each subsequent layer of noise in fractal noise.
##
## A low value places more emphasis on the lower frequency base layers, while
## a high value puts more emphasis on the higher frequency layers.
@export var noise_fractal_gain: float = 0.35:
	get:
		return await _shape_get(&"noise_fractal_gain")
	set(value):
		_shape_set(&"noise_fractal_gain", value)

## Frequency multiplier between subsequent octaves. Increasing this value results in higher
## octaves producing noise with finer details and a rougher appearance.
@export var noise_fractal_lacunarity: float = 25.0:
	get:
		return await _shape_get("noise_fractal_lacunarity")
	set(value):
		_shape_set(&"noise_fractal_lacunarity", value)

# Deligation
var radius: float:
	get:
		return self.asteroid_size.shape_radius
var matter: Array[Matter]:
	get:
		return self.asteroid_kind.matter.keys()

## Used for the click animation.
var click_tween: Tween


func _init() -> void:
	asteroid_size = AsteroidSize.random_size()
	asteroid_kind = FlotsamComposition.random_kind()
	matter_bag = MatterBag.new()


func _ready() -> void:
	rebuild.call_deferred()
	Global.increment_asteroid_count()

	# The setters on @export'd variables aren't called when there is
	# a default and the scene doesn't change it. See godotengine/godot#86494
	# This bit of code forces all the setters to be called on exported (hint'd)
	# variables.
	var usage: int = (
		PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_SCRIPT_VARIABLE
	)
	for prop: Dictionary in get_property_list():
		if prop.usage & usage and (
			prop.type == TYPE_INT or
			prop.type == TYPE_FLOAT or
			prop.type == TYPE_COLOR
		):
			set(prop.name, get(prop.name))


func _physics_process(_delta: float) -> void:
	if is_on_screen():
		if not debuted:
			debuted = true
	elif debuted:
		die()
		return


## Used by setters to set properties on shape.
func _shape_set(prop: StringName, value: Variant) -> void:
	if not shape or not shape.is_inside_tree():
		await ready
	shape.set_deferred(prop, value)


## Used by getters to get properties from shape.
func _shape_get(prop: StringName) -> Variant:
	if not shape or not shape.is_inside_tree():
		await ready
	return shape.get(prop)


## Used by setters to set properties on outline.
func _outline_set(prop: StringName, value: Variant) -> void:
	if not outline or not outline.is_inside_tree():
		await ready
	outline.set_deferred(prop, value)


## Used by getters to get properties from outline.
func _outline_get(prop: StringName) -> Variant:
	if not outline or not outline.is_inside_tree():
		await ready
	return outline.get(prop)


## Sets up the shape, size, color, etc.
func rebuild() -> void:
	if not is_valid():
		push_error("Asteroid.rebuild() called with invalid object.")
		return

	# Save these off, in case we need them.
	last_asteroid_kind = asteroid_kind
	last_asteroid_size = asteroid_size

	# Replace the contents of the bag without disrupting signals.
	matter_bag.replace_bag(_random_matter())

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
	var points: PackedVector2Array = asteroid_size.generate_polygon()

	# Set the shapes.
	shape.set_polygon(points)
	var colors: PackedColorArray = PackedColorArray(
		[
			Color.RED,
			Color.GREEN,
			Color.BLUE,
		],
	)
	color_dark = colors[0]
	color_mid = colors[1]
	color_light = colors[2]

	outline.closed = true
	outline.set_points(points)

	collision_shape.set_polygon(points)


func is_valid() -> bool:
	return asteroid_size && asteroid_kind


## Called when clicked on.
func click() -> void:
	if is_marked_for_absorbtion:
		return

	is_marked_for_absorbtion = true

	click_tween = create_tween()
	click_tween.set_trans(Tween.TRANS_SPRING)
	click_tween.tween_property(
		%Outline,
		"default_color",
		Color(2, 2, 2),
		0.1,
	)
	click_tween.tween_property(
		%Outline,
		"default_color",
		Global.color_nanobots,
		0.2,
	)
	click_tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	click_tween.tween_property(
		%Outline,
		"default_color",
		Global.color_nanobots.clamp().darkened(0.8),
		1.2,
	)
	click_tween.set_trans(Tween.TRANS_LINEAR)
	click_tween.parallel().tween_property(
		%Shape,
		"self_modulate",
		Color(2, 2, 2),
		1.0,
	)


## Contract method for Absorbers.
func be_absorbed() -> void:
	Events.emit_asteroid_hit(self)
	collision_shape.set_disabled.call_deferred(true)
	set_freeze_enabled.call_deferred(true)
	trigger_dissolve.call_deferred()


## Animate the dissolution of the asteroid.
func trigger_dissolve() -> void:
	if dissolve_tween:
		return

	var dissolver_material: ShaderMaterial = load("uid://bbe0mwwx7i71l").duplicate()
	%Group.set_material(dissolver_material)

	# Set the color we're using.
	var color: Color = Global.color_nanobots if is_marked_for_absorbtion else Color.BLACK

	dissolver_material.set_shader_parameter("color", color)

	# Calculate the angle to the player.
	var player_angle: float = global_position.angle_to_point(Global.player_position)

	# Angle to the player.
	var angle: float = TAU * 3.0 / 4.0 - player_angle + TAU * 2.0 / 4.0

	# Compensate for any asteroid rotation.
	angle += rotation

	dissolver_material.set_shader_parameter("rotation", angle)

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
	var target_coord: Vector2
	var direction: float

	# Determine if this asteroid should intercept the player
	var should_intercept: bool = Global.rng.randf() < Global.asteroid_player_intercept_chance

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
	var speed: float = Global.rng.randf_range(10.0, 180.0)
	var velocity: Vector2 = Vector2(speed * get_mass(), 0.0).rotated(direction)

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
	var sides: Array[Asteroid.Side] = [Side.TOP, Side.LEFT, Side.RIGHT, Side.BOTTOM]
	var side_weights: PackedFloat32Array = [5, 1.5, 1.5, 0.2]

	var side_index: int = Global.rng.rand_weighted(side_weights)
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
