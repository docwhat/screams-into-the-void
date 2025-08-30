extends RigidBody2D

# The radius of the asteroid.
@export var radius : int = 32

# Rotation speed in degrees per second.
@export var rotation_speed : float = 32.0

func _ready() -> void:
  $PixelAsteroid.set_seed(Global.rng.randi())
  $PixelAsteroid.set_pixels(radius * 2)
  $PixelAsteroid.set_rotates(rotation_speed)
  $PixelAsteroid.randomize_colors()

  $CollisionShape2D.shape.radius = radius
