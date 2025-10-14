extends Node

var resolution: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height"),
)

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

## The main play field node.
var play_field: CanvasLayer

## The player node.
var player_node: Area2D

## The main viewport.
var viewport: Viewport

## Debugging flags
@export_group("Debugging", "debug_")
@export_subgroup("Asteroid", "debug_asteroid_")
@export var debug_asteroid_launch: bool = false
@export var debug_asteroid_size: bool = false
@export var debug_asteroid_kind: bool = false
@export var debug_asteroid_colors: bool = false

@export_group("")

## Star background
@export_group("Background")
@export_range(0.01, 2.0, 0.01) var star_speed: float = 0.03
@export_group("")

## Player information.
var player_size: Vector2 = Vector2(64, 64)
var player_position: Vector2

@export_group("Asteroids", "asteroid_")

## The number of asteroids currently active on screen (or about to be on screen).
var asteroid_count: int = 0

## The maximum number of asteroids allowed on screen at once.
@export_range(1, 256, 1, "or_greater") var asteroid_max: int = 30

# The minimum and maximum wait time between spawns.
@export var asteroid_min_spawn_timer: float = 0.5
@export var asteroid_max_spawn_timer: float = 4.0

# Controls the randomness of the spawn timer.
@export var asteroid_spawn_randomness: float = 0.2

# The minimum and maximum number of asteroids to add per spawn.
@export var asteroid_min_asteroids_to_add: int = 1
@export var asteroid_max_asteroids_to_add: int = 3

## Chance that an asteroid aims directly for the player. 1.0 == 100%
@export_range(0.0, 1.0, 0.01) var asteroid_player_intercept_chance: float = 0.3

@export_group("")


func _ready() -> void:
	rng.randomize()


## Decrease the asteroid count by one.
func decrement_asteroid_count() -> void:
	asteroid_count = max(0, asteroid_count - 1)


## Increase the asteroid count by one.
func increment_asteroid_count() -> void:
	asteroid_count += 1


## Use this to quit the game. It'll work reliably on all platforms.
##
## See: https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
func quit() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


## Returns 0 or 1 50% of the time.
func flip_coin() -> int:
	return Global.rng.randi_range(0, 1)


## Format a string according to preferred formatter.
func format_number(number: int) -> String:
	return NumberTools.format(
		number,
		GameSave.use_format,
		GameSave.number_grouping_separator,
		GameSave.number_decimal_separator,
	)

# EOF
