extends Node

var matter: MatterBag = MatterBag.new()

var absorber: Absorber = StarterAbsorber.new()

@export_group("Preferences")

@export var use_symbols: bool = false
@export var use_format: NumberTools.NumberFormat = NumberTools.NumberFormat.NONE
@export var number_grouping_separator: NumberTools.NumberGroupSeparator = (
	NumberTools.NumberGroupSeparator.COMMA
)
@export var number_decimal_separator: NumberTools.NumberDecimalSeparator = (
	NumberTools.NumberDecimalSeparator.PERIOD
)

@export_group("")
