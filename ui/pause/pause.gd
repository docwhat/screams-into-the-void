extends Control

# Note to self: This node's "processing" is set to run only when paused.

func _ready() -> void:
	if OS.has_feature("wasm"):
		%Quit.hide()


## When we become visible.
func _on_visibility_changed() -> void:
	if visible:
		# Focus us.
		%Play.grab_focus.call_deferred()


## Quit the game.
func quit() -> void:
	Global.quit()


## Unpause the menu.
func unpause() -> void:
	Events.request_window("PlayFieldState")


## Open the options.
func options() -> void:
	Events.request_window("OptionsState")
