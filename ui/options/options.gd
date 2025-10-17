extends Control

# Note to self: This node's "processing" is set to run only when paused.

func _ready() -> void:
	_set_values.call_deferred()


func _set_values() -> void:
	if not is_node_ready():
		await ready
	%VSyncCheckBox.set_pressed(GameSave.use_vsync)
	%NumberFormatOptionButton.select_by_id(GameSave.use_format)
	%UseSymbolsCheckBox.set_pressed(GameSave.use_symbols)


func _on_visibility_changed() -> void:
	if visible:
		_set_values()
		%VSyncCheckBox.grab_focus.call_deferred()


## When the close button is pressed.
func _on_close_pressed() -> void:
	# TODO: I don't like this.
	# I feel like it should be something like window_thingy.close(me) or something like that.
	Events.request_window("PauseState")


## When the symbols button is checked.checked
func _on_use_symbols_check_box_toggled(toggled_on: bool) -> void:
	GameSave.use_symbols = toggled_on
	# TODO: This should happen automatically when the GameSave value is changed.
	Events.request_hud_update()


## Change the V-Sync when the toggle is changed.
func _on_v_sync_check_box_toggled(toggled_on: bool) -> void:
	GameSave.use_vsync = toggled_on
