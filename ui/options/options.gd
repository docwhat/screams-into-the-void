extends Control

# Note to self: This node's "processing" is set to run only when paused.

func _ready() -> void:
	_init_vsync()
	_init_number_format()


func _on_visibility_changed() -> void:
	if visible:
		%VSync/CheckBox.grab_focus.call_deferred()


## Initialize the VSync setting control.
func _init_vsync() -> void:
	var is_on: bool = GameSave.use_vsync
	%VSync.set_pressed_no_signal(is_on)


## Initialize the number format setting control.
func _init_number_format() -> void:
	%NumberFormat.select(GameSave.use_format)
	%NumberFormat.number_format_changed.connect(_on_number_format_number_format_changed)


func _on_v_sync_toggled(is_on: Variant) -> void:
	var new_mode: DisplayServer.VSyncMode

	if is_on:
		new_mode = DisplayServer.VSYNC_ADAPTIVE
	else:
		new_mode = DisplayServer.VSYNC_DISABLED

	DisplayServer.window_set_vsync_mode(new_mode)
	GameSave.use_vsync = is_on
	Events.request_hud_update()


func _on_number_format_number_format_changed(new_format: NumberTools.NumberFormat) -> void:
	GameSave.use_format = new_format


func _on_close_pressed() -> void:
	# TODO: I don't like this.
	# I feel like it should be something like window_thingy.close(me) or something like that.
	Events.request_window("PauseState")


func _on_use_symbols_toggled(is_on: bool) -> void:
	GameSave.use_symbols = is_on
	Events.request_hud_update()
