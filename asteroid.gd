extends RigidBody2D

# A random asteroid size.
func random_size() -> int:
  # The list of possible asteroid sizes.
  var sizes = [8, 16, 32, 64]

  # The weights (chances) of getting each size.
  var weights : PackedFloat32Array = PackedFloat32Array([0.2, 1, 0.5, 0.1])

  var index = Global.rng.rand_weighted(weights)

  return sizes[index]

func _ready() -> void:
  var new_radius : int = random_size()
  var new_rotation_impulse : float = Global.rng.randf_range(-180, 180)
  var new_mass : float = new_radius * 10.0

  set_mass(new_mass)
  apply_torque_impulse(new_rotation_impulse)

  $PixelAsteroid.set_seed(Global.rng.randi())
  $PixelAsteroid.set_pixels(new_radius * 2)
  $PixelAsteroid.randomize_colors()

  # Center the PixelAsteroid so it lines up with the collision shape.
  $PixelAsteroid.position = Vector2(0.0 - new_radius, 0.0 - new_radius)

  $CollisionShape2D.shape.radius = new_radius
