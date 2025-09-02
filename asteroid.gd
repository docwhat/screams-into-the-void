extends RigidBody2D

static var count : int = 0
var radius : int
var debuted : bool = false

# A random asteroid size.
func random_radius() -> int:
  # The list of possible asteroid sizes and the weights (chances) of getting
  # each size.
  var sizes = [8, 12, 16, 28, 32, 42, 64]
  var wghts = [1, 2, 3, 6, 2, 0.2, 0.1]

  var index = Global.rng.rand_weighted(PackedFloat32Array(wghts))

  return sizes[index]

func generatePoints() -> PackedVector2Array:
  var number_of_points : int = Global.rng.randi_range(5, 12)
  var poly : PackedVector2Array = PackedVector2Array()

  # First point at the chosen radius.
  poly.append(Vector2(radius, 0))

  # The algorithm is to just go around a circle at evenly spaced points at random radii.
  for point in range(1, number_of_points):
    # Randomize the radius.
    var rad : float = Global.rng.randf_range(
      radius - Global.rng.randf_range(0.0, radius * 0.4),
      radius + Global.rng.randf_range(0.0, radius * 0.4)
    )

    # calculate angle (evenly spaced).
    var angle : float = point * PI * 2 / number_of_points
    poly.append(Vector2(rad, 0).rotated(angle))
  return poly

func _ready() -> void:
  radius = random_radius()
  inertia = 10.0 * radius / 64.0

  var new_rotation_impulse : float = Global.rng.randf_range(-8.0, 8.0)
  set_mass(radius)
  apply_torque_impulse(new_rotation_impulse)

  # Image shape.
  var points = generatePoints()
  var poly = Polygon2D.new()
  poly.set_polygon(points)
  poly.set_color(Color(0.7, 0.6, 0.5))
  add_child(poly)

  var max_radius : float = radius
  for point in points:
    max_radius = max(max_radius, point.length())

  # # Collision polygon shape.
  # # This is commented out because I can't get it to be sane. The asteroids
  # # spin like crazy whenever they touch.
  # var collider : CollisionPolygon2D = CollisionPolygon2D.new()
  # collider.set_build_mode(CollisionPolygon2D.BUILD_SOLIDS)
  # collider.set_polygon(points)
  # add_child(collider)

  # Collision circle shape.
  var collider : CollisionShape2D = CollisionShape2D.new()
  # Set the shape to a circle of radius max_radius
  var shape : CircleShape2D = CircleShape2D.new()
  shape.set_radius((max_radius + radius) / 2.0)
  collider.set_shape(shape)
  add_child(collider)

  count += 1

func be_absorbed(_storage) -> void:
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
