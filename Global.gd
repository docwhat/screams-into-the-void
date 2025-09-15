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
