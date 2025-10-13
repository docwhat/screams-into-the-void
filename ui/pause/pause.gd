extends Control

func _ready() -> void:
	if OS.has_feature("wasm"):
		%Quit.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		unpause()
		get_viewport().set_input_as_handled()


func _on_visibility_changed() -> void:
	if visible:
		%Play.grab_focus.call_deferred()


## Quit the game.
func quit() -> void:
	Global.quit()


## Unpause the action.
func unpause() -> void:
	Events.emit_unpause()


## Show the options window.
func show_options() -> void:
	Events.request_options_window(true)


func hide_options() -> void:
	Events.request_options_window(true)
