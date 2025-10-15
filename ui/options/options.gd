extends Control

# Note to self: This node's "processing" is set to run only when paused.

func _ready() -> void:
	%VSync.set_pressed_no_signal(GameSave.use_vsync)
	%NumberFormat.select(GameSave.use_format)
	%UseSymbols.set_pressed_no_signal(GameSave.use_symbols)


func _on_visibility_changed() -> void:
	if visible:
		%VSync/CheckBox.grab_focus.call_deferred()


## Change the V-Sync when the toggle is changed.
func on_v_sync_toggled(is_on: Variant) -> void:
	var new_mode: DisplayServer.VSyncMode

	if is_on:
		new_mode = DisplayServer.VSYNC_ADAPTIVE
	else:
		new_mode = DisplayServer.VSYNC_DISABLED

	DisplayServer.window_set_vsync_mode(new_mode)
	GameSave.use_vsync = is_on


## When the number format is changed.
func on_number_format_changed(new_format: NumberTools.NumberFormat) -> void:
	GameSave.use_format = new_format
	# TODO: This should happen automatically when the GameSave value is changed.
	Events.request_hud_update()


## When the symbols button is checked.checked
func on_use_symbols_toggled(is_on: bool) -> void:
	GameSave.use_symbols = is_on
	# TODO: This should happen automatically when the GameSave value is changed.
	Events.request_hud_update()


## When the close button is pressed.
func _on_close_pressed() -> void:
	# TODO: I don't like this.
	# I feel like it should be something like window_thingy.close(me) or something like that.
	Events.request_window("PauseState")
