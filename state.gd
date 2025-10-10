extends Node

var matter: MatterBag = MatterBag.new()

var absorber: Absorber = StarterAbsorber.new()

@export_group("Preferences")

@export var use_symbols: bool = false
@export var use_format: NumberTools.NumberFormat = NumberTools.NumberFormat.NONE

@export_group("")
