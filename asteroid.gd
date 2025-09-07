extends RigidBody2D

static var count : int = 0
# Has this asteroid been made visible?
var debuted : bool = false

var asteroid_size : AsteroidSize

# Composition
var carbon : int = 0
var water : int = 0
var silicon : int = 0
var metal : int = 0

func _ready() -> void:
  asteroid_size = Global.get_random_asteroid_size()
  inertia = 1000000.0 * asteroid_size.radius

  var new_rotation_impulse : float = Global.rng.randf_range(-8.0, 8.0)
  set_mass(1000.0 * asteroid_size.radius)
  apply_torque_impulse(new_rotation_impulse)

  # Compisition
  carbon = 1
  water = 1
  silicon = 1
  metal = 1

  # Image shape.
  var points = asteroid_size.generatePolygon()
  var poly = Polygon2D.new()
  poly.set_polygon(points)
  poly.set_color(Color(0.7, 0.6, 0.5))
  add_child(poly)

  # Collision polygon shape.
  # This is commented out because I can't get it to be sane. The asteroids
  # spin like crazy whenever they touch.
  var collider : CollisionPolygon2D = CollisionPolygon2D.new()
  collider.set_build_mode(CollisionPolygon2D.BUILD_SOLIDS)
  collider.set_polygon(points)
  collider
  add_child(collider)

  count += 1

func be_absorbed(_storage) -> void:
  SaveState.carbon += carbon
  SaveState.water += water
  SaveState.silicon += silicon
  SaveState.metal += metal
  count -= 1
  # store the resources

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
