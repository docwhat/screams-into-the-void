extends State

func enter(_previous_state_path: String, _data: Dictionary = { }) -> void:
	get_tree().set_pause(false)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	%Pointer.show()


func exit() -> void:
	get_tree().set_pause(true)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	%Pointer.hide()


func pause_or_back() -> void:
	get_parent().pause()
	get_viewport().set_input_as_handled()
