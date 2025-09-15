extends RigidBody2D

static var count : int = 0
# Has this asteroid been made visible?
var debuted : bool = false

var asteroid_size : AsteroidSize

var composition : MatterCollection = MatterCollection.new()

func _ready() -> void:
  asteroid_size = AsteroidSize.get_random_asteroid_size()
  inertia = 1000000.0 * asteroid_size.radius
  set_mass(1000.0 * asteroid_size.radius)

  var new_rotation_impulse : float = Global.rng.randf_range(-8.0, 8.0)
  apply_torque_impulse(new_rotation_impulse)

  # Composition
  composition.fill(1)

  # Image shape.
  var points = asteroid_size.generatePolygon()

  # Visible polygon shape
  var poly : Polygon2D = $Polygon2D
  poly.set_polygon(points)
  var mat: ShaderMaterial = poly.material
  mat.set_shader_parameter("seed", Global.rng.randf() * 1000 / 100.0)
  set_colors(ColorSchemes.randomize_colors())

  asteroid_size.configure_shader(mat)

  # Collision polygon shape.
  var collider : CollisionPolygon2D = $CollisionPolygon2D
  collider.set_polygon(points)

  count += 1

func set_colors(colors : Array[Color]) -> void:
  $Polygon2D.material.set_shader_parameter("colors", colors)

func be_absorbed() -> void:
  Global.collection.add_collection(composition)
  count -= 1

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


func launch(scene : Node, screen_size : Vector2, player_coord : Vector2) -> Node:
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

  # Spawn it by adding to the Main scene
  scene.add_child(self)

  return self
