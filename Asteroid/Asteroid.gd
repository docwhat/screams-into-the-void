class_name Asteroid extends RigidBody2D

static var count : int = 0
# Has this asteroid been made visible?
var debuted : bool = false

var asteroid_size : AsteroidSize
var asteroid_kind : AsteroidKind

@export_group("Dissolve", "dissolve_")
var dissolve_tween : Tween
@export_color_no_alpha var dissolve_color : Color = Color(0.0, 1.0, 0.18, 1.0)
@export_range(0.1, 5.0, 0.1) var dissolve_duration : float = 1.0
@export_range(0.0, 1.5, 0.1) var dissolve_beam_size : float = 0.1
@export_group("")

# Deligation
var radius : float:
  get: return self.asteroid_size.shape_radius
var matter : Array[MatterCollection.Matter]:
  get: return self.asteroid_kind.matter
var noise_size : float:
  get: return self.asteroid_size.shader_noise_size

func _init() -> void:
  asteroid_size = AsteroidSize.random_size()
  asteroid_kind = AsteroidKind.random_kind()

func _ready() -> void:
  # TODO: calculate inertia based on asteroid size and kind.
  assert(radius > 0.0)
  inertia = 1000000.0 * radius
  set_mass(1000.0 * radius)

  # TODO: Move to launch function.
  var new_rotation_impulse : float = Global.rng.randf_range(-8.0, 8.0)
  apply_torque_impulse(new_rotation_impulse)

  # Image shape.
  var points = asteroid_size.generatePolygon()

  # Visible polygon shape
  $Polygon2D.set_polygon(points)

  # Texture Shader setup.
  $Polygon2D.material.set_shader_parameter("seed", Global.rng.randf() * 1000 / 100.0)
  set_colors(asteroid_kind.palette())
  asteroid_size.configure_shader($Polygon2D.material)

  # Collision polygon shape.
  var collider : CollisionPolygon2D = $CollisionPolygon2D
  collider.set_polygon(points)

  count += 1
  
func is_valid() -> bool:
  return  asteroid_size && asteroid_kind

func set_colors(colors : Array[Color]) -> void:
  $Polygon2D.material.set_shader_parameter("colors", colors)

func be_absorbed() -> void:
  Events.emit_asteroid_hit(self)
  $CollisionPolygon2D.set_disabled.call_deferred(true)
  set_freeze_enabled.call_deferred(true)
  trigger_dissolve.call_deferred()
  count -= 1
  
func trigger_dissolve() -> void:
  if dissolve_tween: return
  
  var dissolve_material : ShaderMaterial = $Polygon2D.material
  dissolve_material.set_shader_parameter("dissolving", true)
  dissolve_material.set_shader_parameter("dissolve_progress", 0.0)
  dissolve_material.set_shader_parameter("dissolve_color", dissolve_color)
  dissolve_material.set_shader_parameter("dissolve_noise_density", noise_size * 4.0)
  dissolve_material.set_shader_parameter("dissolve_beam_size", dissolve_beam_size)

  dissolve_tween = create_tween()
  dissolve_tween.tween_property(dissolve_material, "shader_parameter/dissolve_progress", 1.0, dissolve_duration)
  dissolve_tween.tween_callback(func(): queue_free())

func die() -> void:
  count -= 1
  queue_free()

func _physics_process(_delta: float) -> void:
  if is_on_screen():
    if not debuted: debuted = true
  elif debuted:
      die()

# check if the position is within the viewport
func is_on_screen() -> bool:
  var screen : Vector2 = get_viewport().size
  var pos : Vector2 = position # position
  var fudge : float = 64 * 4

  return pos.y >= 0.0 - fudge && \
         pos.x >= 0.0 - fudge && \
         pos.x <= screen.x + fudge && \
         pos.y <= screen.y + fudge

enum Side {
  TOP,
  LEFT,
  RIGHT,
  BOTTOM
}

# Asteroids start off screen. We need to ensure they spawn far enough off screen
# that they can't be seen.
func calculate_asteroid_starting_position(screen_size : Vector2) -> Vector2:
  # Distance from edge of screen to the asteroid off screen.
  var spawn_margin : int = 100

  # Where the asteroid should spawn.
  var sides = [Side.TOP, Side.LEFT, Side.RIGHT, Side.BOTTOM]
  var side_weights : PackedFloat32Array = [5, 1.5, 1.5, 0.2]

  var side_index = Global.rng.rand_weighted(side_weights)
  match sides[side_index]:
    Side.LEFT:
      return Vector2(
        -spawn_margin,
        Global.rng.randf_range(0, screen_size.y)
      )
    Side.RIGHT:
      return Vector2(
        screen_size.x + spawn_margin,
        Global.rng.randf_range(0, screen_size.y)
      )
    Side.BOTTOM:
      return Vector2(
        Global.rng.randf_range(0, screen_size.x),
        screen_size.y + spawn_margin
      )
    Side.TOP, _: # AKA Side.TOP
      return Vector2(
        Global.rng.randf_range(-spawn_margin, screen_size.x + spawn_margin),
        -spawn_margin
      )


func launch(screen_size : Vector2, player_coord : Vector2) -> Node:
  var target_coord : Vector2
  var direction : float

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
      Global.rng.randf_range(0, screen_size.y)
    )
  direction = position.angle_to_point(target_coord)

  # Choose a velocity
  var speed = Global.rng.randf_range(100.0, 150.0)
  var velocity = Vector2(speed, 0.0).rotated(direction)

  # Restore the physics.
  set_freeze_enabled(false)

  # Send it on its way.
  apply_impulse(velocity)

  return self

func random_matter() -> MatterCollection:
  var matter_collection = MatterCollection.new()
  var max_amount : float = radius / 8.0

  if Global.debug_asteroid_kind:
    print_rich("[b]== %s (%f) ==[/b]" % [name, radius])
  for m : MatterCollection.Matter in matter:
    var amount : int = floor(max_amount * Global.rng.randf())
    matter_collection.set_amount(m, amount)
    if Global.debug_asteroid_kind:
      print_rich("   %10s: %-5d" % [MatterCollection.AntiMatter[m], amount])

  return matter_collection
