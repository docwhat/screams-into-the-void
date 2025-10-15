## StateMachine is a Node/Class for containing and managing States.
##
## Based on https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name StateMachine
extends Node

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: State = null

## The current state of the state machine.
@onready var state: State = (func get_initial_state() -> State:
		return initial_state if initial_state != null else get_child(0)
).call()


func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_by_name)

	await owner.ready
	state.enter("")


func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func _transition_by_name(target_state_name: String, data: Dictionary = { }) -> void:
	if not has_node(target_state_name):
		printerr(
			"{owner}: Trying to transition to state {state} but it does not exist.".format(
				{
					"owner": owner.name,
					"state": target_state_name,
				},
			),
		)
		return

	var new_state: State = get_node(target_state_name)
	_transition(new_state, data)


func _transition(new_state: State, data: Dictionary = { }) -> void:
	if new_state.get_parent() != self:
		printerr(
			"{owner}: Trying to transition to state {state} that is not a child of {self}.".format(
				{
					"owner": owner.name,
					"state": new_state.name,
					"self": self.name,
				},
			),
		)
		return

	var previous_state: State = state
	state = new_state

	previous_state.exit()
	new_state.enter(previous_state.name, data)
