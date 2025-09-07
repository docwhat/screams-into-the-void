extends Node

var resolution := Vector2(
    ProjectSettings.get_setting("display/window/size/viewport_width"),
    ProjectSettings.get_setting("display/window/size/viewport_height")
)

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var star_speed : float = 0.01

# Player information.
var player_size : Vector2 = Vector2(64, 64)
var player_position : Vector2

# How much rocks do we have. (PlayerState)
var collection : MatterCollection = MatterCollection.new()

# Asteroid system variables
var asteroid_player_intercept_chance : float = 0.3  # 30% chance asteroids target player
var asteroid_top_down_bias : float = 0.7  # 70% chance asteroids come from top

# Materials. Never delete any. Never change any numbers. Otherwise
# saves won't work.
enum Matter {
    CARBON = 0,
    WATER = 1,
    SILICON = 2,
    IRON = 3,
    COPPER = 4,
    URANIUM = 5
}

# The various asteroid sizes.
var TinyAsteroidSize = AsteroidSize.new(8, 4.0, 1.0)
var SmallAsteroidSize = AsteroidSize.new(12, 5.0, 2.0)
var MediumAsteroidSize = AsteroidSize.new(16, 6.4, 3.0)
var BigAsteroidSize = AsteroidSize.new(28, 12.0, 6.0)
var LargeAsteroidSize = AsteroidSize.new(32, 12.0, 2.0)
var HugeAsteroidSize = AsteroidSize.new(42, 5.0, 0.2)
var GargantuanAsteroidSize = AsteroidSize.new(64, 4.0, 0.1)

var ALL_ASTEROID_SIZES = [
  SmallAsteroidSize,
  MediumAsteroidSize,
  BigAsteroidSize,
  LargeAsteroidSize,
  HugeAsteroidSize,
  GargantuanAsteroidSize
]

func get_random_asteroid_size():
  var weights : PackedFloat32Array

  for size in ALL_ASTEROID_SIZES:
    weights.push_back(size.probability)

  var random_index = rng.rand_weighted(weights)
  return ALL_ASTEROID_SIZES[random_index]
