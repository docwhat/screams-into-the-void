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
static var lithium: Element = Element.create(&"lithium", &"li", 6.94)
static var beryllium: Element = Element.create(&"beryllium", &"be", 9.01)
static var boron: Element = Element.create(&"boron", &"b", 10.81)
static var carbon: Element = Element.create(&"carbon", &"c", 12.01)
static var nitrogen: Element = Element.create(&"nitrogen", &"n", 14.01)
static var oxygen: Element = Element.create(&"oxygen", &"o", 16.00)
static var fluorine: Element = Element.create(&"fluorine", &"f", 19.00)
static var neon: Element = Element.create(&"neon", &"ne", 20.18)
static var sodium: Element = Element.create(&"sodium", &"na", 22.99)
static var magnesium: Element = Element.create(&"magnesium", &"mg", 24.31)
static var aluminum: Element = Element.create(&"aluminum", &"al", 26.98)
static var silicon: Element = Element.create(&"silicon", &"si", 28.09)
static var phosphorus: Element = Element.create(&"phosphorus", &"p", 30.97)
static var sulfur: Element = Element.create(&"sulfur", &"s", 32.06)
static var chlorine: Element = Element.create(&"chlorine", &"cl", 35.45)
static var argon: Element = Element.create(&"argon", &"ar", 39.95)
static var potassium: Element = Element.create(&"potassium", &"k", 39.10)
static var calcium: Element = Element.create(&"calcium", &"ca", 40.08)
static var scandium: Element = Element.create(&"scandium", &"sc", 44.96)
static var titanium: Element = Element.create(&"titanium", &"ti", 47.87)
static var vanadium: Element = Element.create(&"vanadium", &"v", 50.94)
static var chromium: Element = Element.create(&"chromium", &"cr", 52.00)
static var manganese: Element = Element.create(&"manganese", &"mn", 54.94)
static var iron: Element = Element.create(&"iron", &"fe", 55.85)
static var cobalt: Element = Element.create(&"cobalt", &"co", 58.93)
static var nickel: Element = Element.create(&"nickel", &"ni", 58.69)
static var copper: Element = Element.create(&"copper", &"cu", 63.55)
static var zinc: Element = Element.create(&"zinc", &"zn", 65.38)
static var gallium: Element = Element.create(&"gallium", &"ga", 69.72)
static var germanium: Element = Element.create(&"germanium", &"ge", 72.63)
static var arsenic: Element = Element.create(&"arsenic", &"as", 74.92)
static var selenium: Element = Element.create(&"selenium", &"se", 78.96)
static var bromine: Element = Element.create(&"bromine", &"br", 79.90)
static var krypton: Element = Element.create(&"krypton", &"kr", 83.80)
static var rubidium: Element = Element.create(&"rubidium", &"rb", 85.47)
static var strontium: Element = Element.create(&"strontium", &"sr", 87.62)
static var yttrium: Element = Element.create(&"yttrium", &"y", 88.91)
static var zirconium: Element = Element.create(&"zirconium", &"zr", 91.22)
static var niobium: Element = Element.create(&"niobium", &"nb", 92.91)
static var molybdenum: Element = Element.create(&"molybdenum", &"mo", 95.95)
static var technetium: Element = Element.create(&"technetium", &"tc", 98.00)
static var ruthenium: Element = Element.create(&"ruthenium", &"ru", 101.07)
static var rhodium: Element = Element.create(&"rhodium", &"rh", 102.91)
static var palladium: Element = Element.create(&"palladium", &"pd", 106.42)
static var silver: Element = Element.create(&"silver", &"ag", 107.87)
static var cadmium: Element = Element.create(&"cadmium", &"cd", 112.41)
static var indium: Element = Element.create(&"indium", &"in", 114.82)
static var tin: Element = Element.create(&"tin", &"sn", 118.71)
static var antimony: Element = Element.create(&"antimony", &"sb", 121.76)
static var tellurium: Element = Element.create(&"tellurium", &"te", 127.60)
static var iodine: Element = Element.create(&"iodine", &"i", 126.90)
static var xenon: Element = Element.create(&"xenon", &"xe", 131.29)
static var cesium: Element = Element.create(&"cesium", &"cs", 132.91)
static var barium: Element = Element.create(&"barium", &"ba", 137.33)
static var lanthanum: Element = Element.create(&"lanthanum", &"la", 138.91)
static var cerium: Element = Element.create(&"cerium", &"ce", 140.12)
static var praseodymium: Element = Element.create(&"praseodymium", &"pr", 140.91)
static var neodymium: Element = Element.create(&"neodymium", &"nd", 144.24)
static var promethium: Element = Element.create(&"promethium", &"pm", 145.00)
static var samarium: Element = Element.create(&"samarium", &"sm", 150.36)
static var europium: Element = Element.create(&"europium", &"eu", 151.96)
static var gadolinium: Element = Element.create(&"gadolinium", &"gd", 157.25)
static var terbium: Element = Element.create(&"terbium", &"tb", 158.93)
static var dysprosium: Element = Element.create(&"dysprosium", &"dy", 162.50)
static var holmium: Element = Element.create(&"holmium", &"ho", 164.93)
static var erbium: Element = Element.create(&"erbium", &"er", 167.26)
static var thulium: Element = Element.create(&"thulium", &"tm", 168.93)
static var ytterbium: Element = Element.create(&"ytterbium", &"yb", 173.05)
static var lutetium: Element = Element.create(&"lutetium", &"lu", 174.97)
static var hafnium: Element = Element.create(&"hafnium", &"hf", 178.49)
static var tantalum: Element = Element.create(&"tantalum", &"ta", 180.95)
static var tungsten: Element = Element.create(&"tungsten", &"w", 183.84)
static var rhenium: Element = Element.create(&"rhenium", &"re", 186.21)
static var osmium: Element = Element.create(&"osmium", &"os", 190.23)
static var iridium: Element = Element.create(&"iridium", &"ir", 192.22)
static var platinum: Element = Element.create(&"platinum", &"pt", 195.08)
static var gold: Element = Element.create(&"gold", &"au", 196.97)
static var mercury: Element = Element.create(&"mercury", &"hg", 200.59)
static var thallium: Element = Element.create(&"thallium", &"tl", 204.38)
static var lead: Element = Element.create(&"lead", &"pb", 207.20)
static var bismuth: Element = Element.create(&"bismuth", &"bi", 208.98)
static var polonium: Element = Element.create(&"polonium", &"po", 209.00)
static var astatine: Element = Element.create(&"astatine", &"at", 210.00)
static var radon: Element = Element.create(&"radon", &"rn", 222.00)
static var francium: Element = Element.create(&"francium", &"fr", 223.00)
static var radium: Element = Element.create(&"radium", &"ra", 226.00)
static var actinium: Element = Element.create(&"actinium", &"ac", 227.00)
static var thorium: Element = Element.create(&"thorium", &"th", 232.04)
static var protactinium: Element = Element.create(&"protactinium", &"pa", 231.04)
static var uranium: Element = Element.create(&"uranium", &"u", 238.03)

# Molecules
static var water: Molecule = Molecule.create(&"water", &"h2o", 2 * hydrogen.mass + oxygen.mass)
