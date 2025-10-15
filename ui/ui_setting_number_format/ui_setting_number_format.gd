@tool
extends HBoxContainer

@onready var label: Label = $Label
@onready var option_button: OptionButton = $OptionButton

## Emitted when the format changes.
signal number_format_changed(new_format: NumberTools.NumberFormat)

## The text on the label of this setting.
@export var title: String = "label":
	set(value):
		if not is_node_ready():
			await ready
		label.text = value
	get():
		return label.text


func _ready() -> void:
	# Here for ease of reference.
	var formats = NumberTools.NumberFormat

	if Engine.is_editor_hint():
		option_button.add_item("none", formats.NONE)
	option_button.add_item("short", formats.SHORT_SCALE)
	option_button.add_item("engineer", formats.ENGINEERING)
	option_button.add_item("science", formats.SCIENTIFIC)


## Forward the requested format to the control.
func select(format: NumberTools.NumberFormat) -> void:
	option_button.selected = format as int


## Emit the newly selected format via our signal.
func _on_option_button_item_selected(index: int) -> void:
	number_format_changed.emit(index as NumberTools.NumberFormat)
