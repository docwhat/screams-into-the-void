@tool
@abstract
class_name Matter
extends Resource

var _name: StringName
var _symbol: StringName

## The name of the Matter.
var name: StringName:
	get():
		return _name

## The chemical symbol(s) of the Matter.
var symbol: StringName:
	get():
		return _symbol

var mass: float

## The name, as set in user preferences.
var preferred_name: String:
	get():
		return str(_symbol if GameSave.use_symbols else _name)


func _init(name_: String, symbol_: String, mass_: float = 0.0) -> void:
	if name_ != "":
		_name = name_.to_lower()
	if symbol_ != "":
		_symbol = symbol_.to_lower()
	if mass_ != 0.0:
		mass = mass_
