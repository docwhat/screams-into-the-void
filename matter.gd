@tool
@abstract
class_name Matter
extends Resource

## The name of the Matter.
var name: StringName:
	get():
		return name
	set(value):
		if not name:
			name = value.to_lower()

## The chemical symbol(s) of the Matter.
var symbol: StringName:
	get():
		return symbol
	set(value):
		if not symbol:
			symbol = value.to_lower()

var mass: float

## An array of all registered Matter types.
static var all_matter: Array[Matter] = []

## A lookup dictionary for Matter by name.
static var by_name: Dictionary[StringName, Matter] = { }

## A lookup dictionary for Matter by symbol.
static var by_symbol: Dictionary[StringName, Matter] = { }

## The name, as set in user preferences.
var preferred_name: String:
	get():
		return str(symbol if GameSave.use_symbols else name)


## A factory method to create Matter instances.
## It returns the new Matter object or null if a duplicate name or symbol is detected.
static func create(name_: StringName, symbol_: StringName, mass_: float) -> Matter:
	var new_matter: Matter

	# GDScript doesn't have a way to get to the class the static method is being called on,
	# so we have to infer it from the symbol.
	# If the symbol is longer than 2 characters or has a number, then it is a Molecule.
	# else, it is an Element.
	if symbol_.length() > 2 or symbol_.findn("[0-9]") != -1:
		new_matter = Molecule.new()
	else:
		new_matter = Element.new()

	if name_ in by_name:
		return null
	if symbol_ in by_symbol:
		return null

	new_matter.name = name_
	new_matter.symbol = symbol_
	new_matter.mass = mass_

	all_matter.append(new_matter)
	by_name[new_matter.name] = new_matter
	by_symbol[new_matter.symbol] = new_matter

	return new_matter


func _init(name_: StringName = "", symbol_: StringName = "", mass_: float = 0.0) -> void:
	if name_ != "":
		name = name_
	if symbol_ != "":
		symbol = symbol_
	if mass_ != 0.0:
		mass = mass_

# Elements
static var hydrogen: Element = Element.create(&"hydrogen", &"h", 1.01)
static var helium: Element = Element.create(&"helium", &"he", 4.00)
static var carbon: Element = Element.create(&"carbon", &"c", 12.01)
static var nitrogen: Element = Element.create(&"nitrogen", &"n", 14.01)
static var oxygen: Element = Element.create(&"oxygen", &"o", 16.00)
static var magnesium: Element = Element.create(&"magnesium", &"mg", 24.31)
static var silicon: Element = Element.create(&"silicon", &"si", 28.09)
static var sulfer: Element = Element.create(&"sulfer", &"s", 32.06)
static var iron: Element = Element.create(&"iron", &"fe", 55.85)
static var nickel: Element = Element.create(&"nickel", &"ni", 58.69)
static var copper: Element = Element.create(&"copper", &"cu", 63.55)
static var uranium: Element = Element.create(&"uranium", &"u", 238.03)

# Molecules
static var water: Molecule = Molecule.create(&"water", &"h2o", 2 * hydrogen.mass + oxygen.mass)
