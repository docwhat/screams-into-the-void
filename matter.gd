@tool
@abstract
class_name Matter
extends Resource

var name: StringName
var symbol: String
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
		# TODO: Remove the dependency on GameSave.
		return symbol if GameSave.use_symbols else str(name)


func _init(name_: StringName, symbol_: StringName, mass_: float) -> void:
	name = name_.to_lower()
	symbol = symbol_.to_lower()
	mass = mass_
	all_matter.append(self)

	# Throw an error if there is a duplicate name or symbol.
	if name in by_name:
		push_error("Duplicate Matter name: %s" % name)
	else:
		by_name[name] = self

	if symbol in by_symbol:
		push_error("Duplicate Matter symbol: %s" % symbol)
	else:
		by_symbol[symbol] = self

	all_matter.sort_custom(func sort_by_mass(a: Matter, b: Matter) -> bool: return a.mass < b.mass)

# Elements
static var hydrogen = Element.new(&"hydrogen", &"h", 1.01)
static var helium = Element.new(&"helium", &"he", 4.00)
static var carbon = Element.new(&"carbon", &"c", 12.01)
static var nitrogen = Element.new(&"nitrogen", &"n", 14.01)
static var oxygen = Element.new(&"oxygen", &"o", 16.00)
static var magnesium = Element.new(&"magnesium", &"mg", 24.31)
static var silicon = Element.new(&"silicon", &"si", 28.09)
static var sulfer = Element.new(&"sulfer", &"s", 32.06)
static var iron = Element.new(&"iron", &"fe", 55.85)
static var nickel = Element.new(&"nickel", &"ni", 58.69)
static var copper = Element.new(&"copper", &"cu", 63.55)
static var uranium = Element.new(&"uranium", &"u", 238.03)

# Molecules
static var water = Molecule.new(&"water", &"h2o", 2 * hydrogen.mass + oxygen.mass)
