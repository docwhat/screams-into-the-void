extends RigidBody2D

static var count : int = 0
var radius : int
var debuted : bool = false

# A random asteroid size.
func random_size() -> int:
  # The list of possible asteroid sizes.
  var sizes = [8, 16, 32, 64]

  # The weights (chances) of getting each size.
  var weights : PackedFloat32Array = PackedFloat32Array([0.2, 1, 0.5, 0.1])

  var index = Global.rng.rand_weighted(weights)

  return sizes[index]

func _ready() -> void:
  var radius : int = random_size()
  var new_rotation_impulse : float = Global.rng.randf_range(-10.0, 10.0)

  inertia = 10.0 * radius / 64.0
  set_mass(radius * 1000.0)
  apply_torque_impulse(new_rotation_impulse)

  $PixelAsteroid.set_seed(Global.rng.randi())
  $PixelAsteroid.set_pixels(radius * 2)
  $PixelAsteroid.randomize_colors()

  # Center the PixelAsteroid so it lines up with the collision shape.
  $PixelAsteroid.position = Vector2(0.0 - radius, 0.0 - radius)

  $CollisionShape2D.shape.radius = radius
  count += 1

  print_rich("Count %d" % count)

func be_absorbed(_storage) -> void:
  count -= 1
  print_rich("asteroid absorbed!   pos: %s" % [position])
  pass # store the resources

func _physics_process(delta: float) -> void:
  if is_on_screen():
    if not debuted:
      debuted = true
  else:
    if debuted:
      print_rich("asteroid offscreen!  pos: %s   screen: %s" % [position, get_viewport().size])
      count -= 1
      queue_free()
    

func is_on_screen() -> bool:
  # check if the position is within the viewport
  var screen : Vector2 = get_viewport().size
  var pos : Vector2 = position # position
  var fudge : float = 64 * 4

  return pos.y >= 0.0 - fudge && \
         pos.x >= 0.0 - fudge && \
         pos.x <= screen.x + fudge && \
         pos.y <= screen.y + fudge

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
  return
  # Return if the asteroid is on screen.
  if is_on_screen():
    print_rich("bad notification!   pos: %s" % [position])
    return

  print_rich("asteroid offscreen!  pos: %s   screen: %s" % [position, get_viewport().size])
  count -= 1
  queue_free()
