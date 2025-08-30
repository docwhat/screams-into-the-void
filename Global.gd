extends Node

var resolution := Vector2(
    ProjectSettings.get_setting("display/window/size/viewport_width"),
    ProjectSettings.get_setting("display/window/size/viewport_height")
)

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var star_speed : float = 0.01

const player_size : Vector2 = Vector2(64, 64)

# Asteroid system variables
var asteroid_player_intercept_chance : float = 0.3  # 30% chance asteroids target player
var asteroid_top_down_bias : float = 0.7  # 70% chance asteroids come from top
