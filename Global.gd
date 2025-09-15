extends Node

var resolution := Vector2(
    ProjectSettings.get_setting("display/window/size/viewport_width"),
    ProjectSettings.get_setting("display/window/size/viewport_height")
)

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var debug_asteroid_size : bool = OS.is_debug_build() && false

# Star background
var star_speed : float = 0.03

# Player information.
var player_size : Vector2 = Vector2(64, 64)
var player_position : Vector2

# How much rocks do we have. (PlayerState)
var collection : MatterCollection = MatterCollection.new()

# Chance that an asteroid aims directly for the player. 1.0 == 100%
var asteroid_player_intercept_chance : float = 0.3

# Change that an asteroid is spawned, weighted. The number of asteroids is
# the index.
var asteroid_spawn_chances : Array[float] = [1, 6, 4, 2, 1, 0.5, 0.25, 0.125, 0.0625]

# The number of asteroids to spawn based on the spawn chances.
func number_of_asteroids_to_spawn() -> int:
  return rng.rand_weighted(asteroid_spawn_chances)

# Use this to quit the game. It'll work
# reliably on all platforms.
# See: https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
func quit() -> void:
  get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
  get_tree().quit()

# Signals
@warning_ignore_start("UNUSED_SIGNAL")
signal on_unpause_command()
@warning_ignore_restore("UNUSED_SIGNAL")

# EOF
