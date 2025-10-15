extends State

func exit() -> void:
	get_tree().set_pause(true)


func enter(_previous_state_path: String, _data: Dictionary = { }) -> void:
	get_tree().set_pause(false)


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_parent().pause()
		get_viewport().set_input_as_handled()
