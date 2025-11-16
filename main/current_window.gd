extends StateMachine

func _ready() -> void:
	Events.window_requested.connect(_transition_by_name)


func pause_or_back() -> void:
	if state.has_method(&"pause_or_back"):
		state.pause_or_back()


func is_play_field() -> bool:
	return state.name == &"PlayFieldState"


func is_pause() -> bool:
	return state.name == &"PauseState"


func is_options() -> bool:
	return state.name == &"OptionsState"


## Transition to the PlayField.
func play_field() -> void:
	_transition_by_name(&"PlayFieldState")


## Transition to the pause screen.
func pause() -> void:
	_transition_by_name(&"PauseState")


## Transition to the options screen.
func options() -> void:
	_transition_by_name(&"OptionsState")
