extends Node

# Signal Bus pattern. All signals go here.

signal asteroid_hit


## Signal that an asteroid hit the player.
func emit_asteroid_hit(asteroid: Asteroid) -> void:
	asteroid_hit.emit(asteroid)

## A window has been requested to be shown.
signal window_requested(state_name: String)


## Signal to the game that a specific window is requested.
func request_window(state_name: String) -> void:
	window_requested.emit(state_name)

## A request has been made to update the HUD (score keeper).
signal update_hud_requested(matter: Matter)


## Request that the HUD (score keeper) be updated.
func request_hud_update(matter: Matter = null) -> void:
	update_hud_requested.emit(matter)


signal asteroid_clicked(asteroid: Asteroid)


## Signal that an asteroid was clicked (via mouse, keyboard, whatever).
func click_asteroid(asteroid: Asteroid) -> void:
	asteroid_clicked.emit(asteroid)
