extends State

func enter(_previous_state_path: String, _data: Dictionary = { }) -> void:
	%PauseMenu.show()


func exit() -> void:
	%PauseMenu.hide()


func pause_or_back() -> void:
	get_parent().play_field()
	get_viewport().set_input_as_handled()
