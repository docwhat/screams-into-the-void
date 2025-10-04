extends Node

# Signal Bus pattern. All signals go here.

signal asteroid_hit


func emit_asteroid_hit(asteroid: Asteroid) -> void:
	asteroid_hit.emit(asteroid)

# Send to unpause the game.
# Listen if you need to perform an action when the game resumes.
signal unpause


func emit_unpause() -> void:
	unpause.emit()

# Send to pause the game.
# Listen if you need to perform an action when the game is paused.
signal pause


func emit_pause() -> void:
	pause.emit()
