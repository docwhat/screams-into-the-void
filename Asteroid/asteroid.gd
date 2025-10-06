class_name Asteroid
extends RigidBody2D

static var count: int = 0

## Has this asteroid been made visible?
var debuted: bool = false

@export var asteroid_size: AsteroidSize
@export var asteroid_kind: AsteroidKind
var last_asteroid_size: AsteroidSize
var last_asteroid_kind: AsteroidKind

@export_group("Dissolve", "dissolve_")
var dissolve_tween: Tween
@export_color_no_alpha var dissolve_color: Color = Color(0.0, 1.0, 0.18, 1.0)
@export_range(0.1, 5.0, 0.1) var dissolve_duration: float = 1.0
@export_range(0.0, 1.5, 0.1) var dissolve_beam_size: float = 0.1
@export_group("")

var matter_collection: MatterBag

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

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


## Sets up the shape, size, color, etc.
func rebuild() -> void:
	if not is_valid():
		push_error("Asteroid.rebuild() called with invalid object.")
		return

	# Save these off, in case we need them.
	last_asteroid_kind = asteroid_kind
	last_asteroid_size = asteroid_size

	matter_collection = _random_matter()

	assert(radius > 0.0)
	var m: float = 0.0
	for mat: Matter in matter_collection.keys():
		m += mat.mass * matter_collection.get_by_matter(mat)
	m += 1.0001
	assert(m > 1.0)
	#set_inertia(1_000_000.0 * radius)
	#set_mass(1_000.0 * radius)
	set_inertia(m * 10_000_000.0)
	set_mass(m * 1_000.0)

	PhysicsServer2D.body_reset_mass_properties(get_rid())
	#var i : float = 1.0 / PhysicsServer2D.body_get_direct_state(get_rid()).inverse_inertia
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
	collision_polygon_2d.set_polygon(points)

	# Texture Shader setup.
	$Polygon2D.material.set_shader_parameter("seed", Global.rng.randf() * 1000 / 100.0)
	asteroid_size.configure_shader($Polygon2D.material)
	asteroid_kind.configure_shader($Polygon2D.material)


## Fling an asteroid at someone.
func launch(screen_size: Vector2, player_coord: Vector2) -> Node:
	var target_coord: Vector2
	var direction: float

	# Determine if this asteroid should intercept the player
	var should_intercept = Global.rng.randf() < Global.asteroid_player_intercept_chance

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

	var dissolve_material: ShaderMaterial = $Polygon2D.material
	dissolve_material.set_shader_parameter("dissolving", true)
	dissolve_material.set_shader_parameter("dissolve_progress", 0.0)
	dissolve_material.set_shader_parameter("dissolve_color", dissolve_color)
	dissolve_material.set_shader_parameter("dissolve_noise_density", noise_size * 4.0)
	dissolve_material.set_shader_parameter("dissolve_beam_size", dissolve_beam_size)

	dissolve_tween = create_tween()
	dissolve_tween.tween_property(
		dissolve_material,
		"shader_parameter/dissolve_progress",
		1.0,
		dissolve_duration,
	)
	dissolve_tween.tween_callback(func(): queue_free())


## Buh-bye.
func die() -> void:
	count -= 1
	get_parent().remove_child(self)
	queue_free()


func _physics_process(_delta: float) -> void:
	if is_on_screen():
		if not debuted:
			debuted = true
	elif debuted:
		die()


## check if the position is within the viewport
func is_on_screen() -> bool:
	var screen: Vector2 = get_viewport().size
	var pos: Vector2 = position # position
	var fudge: float = 64 * 4

	return pos.y >= 0.0 - fudge && \
	pos.x >= 0.0 - fudge && \
	pos.x <= screen.x + fudge && \
	pos.y <= screen.y + fudge


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
