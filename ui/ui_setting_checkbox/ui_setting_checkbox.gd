@tool
extends HBoxContainer

@onready var label: Label = $Label
@onready var check_box: CheckBox = $CheckBox

## Emitted when the [code]CheckBox[/code] state changes for any reason.
signal toggled(is_button_pressed: bool)

## The text on the label of this setting.
@export var title: String = "label":
	set(value):
		if not is_node_ready():
			await ready
		label.text = value
	get():
		return label.text


## Set the checkbox as pressed. This will trigger the toggled
## signal.
func set_pressed(pressed: bool) -> void:
	check_box.button_pressed = pressed


## Set the checkbox as pressed without emitting a signal.
func set_pressed_no_signal(pressed: bool) -> void:
	check_box.set_pressed_no_signal(pressed)


## Handle signal from check_box when toggled.
func _on_check_box_toggled(button_pressed: bool) -> void:
	toggled.emit(button_pressed)
