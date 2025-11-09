extends Node

## Keyboard & Mouse specific bindings.
@export_group("Keyboard & Mouse", "km_")

## Global mappings
@export var km_global: GUIDEMappingContext

## PlayField mappings
@export var km_play_field: GUIDEMappingContext

## Controller specific bindings.
@export_group("Controller", "c_")

## Global mappings
@export var c_global: GUIDEMappingContext

## PlayField mappings
@export var c_play_field: GUIDEMappingContext

## Touch Screen specific bindings.
@export_group("TouchScreen", "t_")

## Global mappings
@export var t_global: GUIDEMappingContext

## PlayField mappings
@export var t_play_field: GUIDEMappingContext


## Actions
@export_group("Actions", "action_")

## The key or button that will pause the game or go back one
## scene (where applicable).
@export var action_pause_or_back: GUIDEAction
@export var action_switch_to_keyboard:GUIDEAction
@export var action_switch_to_joystick:GUIDEAction
@export var action_switch_to_touch:GUIDEAction

@onready var current_window: Node = %CurrentWindow


## Run once the node is attached to the tree and it's children are ready.
func _ready():
	action_pause_or_back.triggered.connect(current_window.pause_or_back)
	
	action_switch_to_joystick.triggered.connect(_to_controller)
	action_switch_to_keyboard.triggered.connect(_to_keyboard_and_mouse)
	action_switch_to_touch.triggered.connect(_to_touch)
	
	# The starting default.
	_to_keyboard_and_mouse()


## Switch to using the controller.
func _to_controller() -> void:
	GUIDE.enable_mapping_context(c_global, true)
	if current_window.is_play_field():
		GUIDE.enable_mapping_context(c_play_field)

## Switch to use the keyboard and mouse.
func _to_keyboard_and_mouse() -> void:
	GUIDE.enable_mapping_context(km_global, true)
	if current_window.is_play_field():
		GUIDE.enable_mapping_context(km_play_field)
	
## Switch to use touch screen.
func _to_touch() -> void:
	GUIDE.enable_mapping_context(t_global, true)
	if current_window.is_play_field():
		GUIDE.enable_mapping_context(t_play_field)
	
