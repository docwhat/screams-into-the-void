@tool
@abstract
class_name Matter
extends Resource

var name: StringName
var symbol: String
var mass: float

## An array of all registered Matter types.
static var all_matter: Array[Matter] = []

## A lookup dictionary from name to Matter instance.
static var lookup: Dictionary[StringName, Matter] = { }

## The name, as set in user preferences.
var preferred_name: String:
	get():
		return symbol if State.use_symbols else str(name)


func _init(name_: StringName, symbol_: String, mass_: float) -> void:
	name = name_
	symbol = symbol_
	mass = mass_
	all_matter.append(self)
	lookup[self.name] = self
	all_matter.sort_custom(func sort_by_mass(a: Matter, b: Matter) -> bool: return a.mass < b.mass)

# Elements
static var hydrogen = Element.new(&"hydrogen", "H", 1.01)
static var helium = Element.new(&"helium", "He", 4.00)
static var carbon = Element.new(&"carbon", "C", 12.01)
static var nitrogen = Element.new(&"nitrogen", "N", 14.01)
static var oxygen = Element.new(&"oxygen", "O", 16.00)
static var magnesium = Element.new(&"magnesium", "Mg", 24.31)
static var silicon = Element.new(&"silicon", "Si", 28.09)
static var sulfer = Element.new(&"sulfer", "S", 32.06)
static var iron = Element.new(&"iron", "Fe", 55.85)
static var nickel = Element.new(&"nickel", "Ni", 58.69)
static var copper = Element.new(&"copper", "Cu", 63.55)
static var uranium = Element.new(&"uranium", "U", 238.03)

# Molecules
static var water = Molecule.new(&"water", "H2O", 2 * hydrogen.mass + oxygen.mass)
