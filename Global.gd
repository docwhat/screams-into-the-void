extends Node

var resolution := Vector2(
    ProjectSettings.get_setting("display/window/size/viewport_width"),
    ProjectSettings.get_setting("display/window/size/viewport_height")
)

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var star_speed : float = 0.01

const player_size : Vector2 = Vector2(64, 64)
