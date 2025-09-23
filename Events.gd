extends Node

# Signal Bus pattern. All signals go here.

signal asteroid_hit
func emit_asteroid_hit(kind: AsteroidKind, size: AsteroidSize) -> void:
  asteroid_hit.emit(kind, size)

# Send to update the HUD.
# Listen if you need to do something when the HUD is updated.
signal update_hud
func emit_update_hud() -> void:
  update_hud.emit()

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
