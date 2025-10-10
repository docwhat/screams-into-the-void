extends Node

var resolution: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height"),
)

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

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

## Chance that an asteroid aims directly for the player. 1.0 == 100%
@export_range(0.0, 1.0, 0.01) var asteroid_player_intercept_chance: float = 0.3

## Change that an asteroid is spawned, weighted. The number of asteroids is
## the index.
@export_range(0, 96, 1, "or_greater") var asteroid_spawn_chances: Array[float] = [
	16,
	96,
	40,
	20,
	8,
	2,
	1,
]
@export_group("")


## The number of asteroids to spawn based on the spawn chances.
func number_of_asteroids_to_spawn() -> int:
	return rng.rand_weighted(asteroid_spawn_chances)


func _ready() -> void:
	rng.randomize()


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
	return NumberTools.format(State.use_format, number)

# EOF
