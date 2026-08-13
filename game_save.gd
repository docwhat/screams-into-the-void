extends Node

var matter: MatterBag = MatterBag.new()

var absorber: Absorber = StarterAbsorber.new()

@export_group("Options")

# TODO: This should use signals to tell something else to make the vsync change.
## Does the player want us to use VSync?
@export var use_vsync: bool = true:
	set(value):
		var new_mode: DisplayServer.VSyncMode
		if value:
			new_mode = DisplayServer.VSYNC_ENABLED
		else:
			new_mode = DisplayServer.VSYNC_DISABLED
		DisplayServer.window_set_vsync_mode(new_mode)
	get:
		var mode: DisplayServer.VSyncMode = DisplayServer.window_get_vsync_mode()
		return mode != DisplayServer.VSYNC_DISABLED

## Notification for when the use_symbols value changes.
signal use_symbols_changed
## Use the short symbols or the full names for matter?
@export var use_symbols: bool = false:
	set(value):
		use_symbols = value
		use_symbols_changed.emit()

## Notification for when the number format changes.
signal use_format_changed()

## Which number format should we use?
@export var use_format: NumberTools.NumberFormat = NumberTools.NumberFormat.NONE:
	set(value):
		use_format = value
		use_format_changed.emit()

## What should we use to separate decimals from fractions?
@export var number_decimal_separator: NumberTools.NumberDecimalSeparator = (
	NumberTools.NumberDecimalSeparator.PERIOD
)

## What should we use to separate number groups. i.e., the comma thousands in the USA.
@export var number_grouping_separator: NumberTools.NumberGroupSeparator = (
	NumberTools.NumberGroupSeparator.COMMA
)

@export_group("")
