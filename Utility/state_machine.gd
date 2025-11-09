## StateMachine is a Node/Class for containing and managing states.
##
## Based on https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
class_name StateMachine
extends Node

## The initial state of the state machine. If not set, the first child node is used.
@export var initial_state: State = null:
	get():
		if initial_state != null:
			return initial_state
		if states.size() > 0:
			return states[0]
		return null
	set(value):
		initial_state = value

## The current state of the state machine.
@onready var state: State = null:
	get():
		return state if state != null else initial_state
	set(value):
		state = value

## A list of all the child {State} nodes in the tree.
var states: Array[State]:
	get():
		if not is_node_ready():
			await ready
		var children: Array[State] = []
		for child: State in find_children("*", "State"):
			children.append(child as State)
		return children


func _ready() -> void:
	for state_node: State in states:
		state_node.finished.connect(_transition_by_name)

	if owner:
		await owner.ready
	state.enter("")


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
