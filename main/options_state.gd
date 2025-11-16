extends State

func enter(_previous_state_path: String, _data: Dictionary = { }) -> void:
	%OptionsMenu.show()


func exit() -> void:
	%OptionsMenu.hide()


func pause_or_back() -> void:
	get_parent().pause()
	get_viewport().set_input_as_handled()
