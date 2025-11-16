extends State

func enter(_previous_state_path: String, _data: Dictionary = { }) -> void:
	get_tree().set_pause(false)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


func exit() -> void:
	get_tree().set_pause(true)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func pause_or_back() -> void:
	get_parent().pause()
	get_viewport().set_input_as_handled()
