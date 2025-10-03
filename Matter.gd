@abstract
class_name Matter extends Resource

var name : String
var symbol : String
var mass : float

static var ALL : Array[Matter]

var preferred_name: String:
	get():
		return symbol if State.use_symbols else name

func _init(name_ : String, symbol_ : String, mass_ : float) -> void:
	name = name_
	symbol = symbol_
	mass = mass_
	ALL.append(self)
	ALL.sort_custom(func sort_by_mass(a: Matter, b: Matter) -> bool: return a.mass < b.mass)

# Elements
static var Hydrogen = Element.new("Hydrogen", "H", 1.01)
static var Helium = Element.new("Helium", "He", 4.00)
static var Carbon = Element.new("Carbon", "C", 12.01)
static var Nitrogen = Element.new("Nitrogen", "N", 14.01)
static var Oxygen = Element.new("Oxygen", "O", 16.00)
static var Magnesium = Element.new("Magnesium", "Mg", 24.31)
static var Silicon = Element.new("Silicon", "Si", 28.09)
static var Sulfer = Element.new("Sulfer", "S", 32.06)
static var Iron = Element.new("Iron", "Fe", 55.85)
static var Nickel = Element.new("Nickel", "Ni", 58.69)
static var Copper = Element.new("Copper", "Cu", 63.55)
static var Uranium = Element.new("Uranium", "U", 238.03)

# Molecules
static var Water = Molecule.new("Water", "H2O", 2 * Hydrogen.mass + Oxygen.mass)
