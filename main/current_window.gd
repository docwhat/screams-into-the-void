extends StateMachine

func _ready() -> void:
	Events.window_requested.connect(_transition_by_name)
# TODO: Is there a way to create methods dynamically?


## Transition to the PlayField.
func play_field() -> void:
	_transition_by_name("PlayFieldState")


## Transition to the pause screen.
func pause() -> void:
	_transition_by_name("PauseState")


## Transition to the options screen.
func options() -> void:
	_transition_by_name("OptionsState")
