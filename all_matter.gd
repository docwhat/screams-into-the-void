## The complete list of all elements and molecules.
@tool
extends Node

var all: Array[Matter]:
	get():
		return matter.all

var matter: MatterRegistry = MatterRegistry.new()


func get_by_name(name_: String) -> Matter:
	return matter.get_by_name(name_)


func get_by_symbol(symbol: String) -> Matter:
	return matter.get_by_symbol(symbol)


func has_name(name_: String) -> bool:
	return matter.has_name(name_)


func has_symbol(symbol: String) -> bool:
	return matter.has_symbol(symbol)


func names() -> Array[String]:
	return matter.by_name.keys()


func symbols() -> Array[String]:
	return matter.by_symbol.keys()

# Elements
var hydrogen: Element = matter.create_element(&"hydrogen", &"h", 1.01)
var helium: Element = matter.create_element(&"helium", &"he", 4.00)
var lithium: Element = matter.create_element(&"lithium", &"li", 6.94)
var beryllium: Element = matter.create_element(&"beryllium", &"be", 9.01)
var boron: Element = matter.create_element(&"boron", &"b", 10.81)
var carbon: Element = matter.create_element(&"carbon", &"c", 12.01)
var nitrogen: Element = matter.create_element(&"nitrogen", &"n", 14.01)
var oxygen: Element = matter.create_element(&"oxygen", &"o", 16.00)
var fluorine: Element = matter.create_element(&"fluorine", &"f", 19.00)
var neon: Element = matter.create_element(&"neon", &"ne", 20.18)
var sodium: Element = matter.create_element(&"sodium", &"na", 22.99)
var magnesium: Element = matter.create_element(&"magnesium", &"mg", 24.31)
var aluminum: Element = matter.create_element(&"aluminum", &"al", 26.98)
var silicon: Element = matter.create_element(&"silicon", &"si", 28.09)
var phosphorus: Element = matter.create_element(&"phosphorus", &"p", 30.97)
var sulfur: Element = matter.create_element(&"sulfur", &"s", 32.06)
var chlorine: Element = matter.create_element(&"chlorine", &"cl", 35.45)
var argon: Element = matter.create_element(&"argon", &"ar", 39.95)
var potassium: Element = matter.create_element(&"potassium", &"k", 39.10)
var calcium: Element = matter.create_element(&"calcium", &"ca", 40.08)
var scandium: Element = matter.create_element(&"scandium", &"sc", 44.96)
var titanium: Element = matter.create_element(&"titanium", &"ti", 47.87)
var vanadium: Element = matter.create_element(&"vanadium", &"v", 50.94)
var chromium: Element = matter.create_element(&"chromium", &"cr", 52.00)
var manganese: Element = matter.create_element(&"manganese", &"mn", 54.94)
var iron: Element = matter.create_element(&"iron", &"fe", 55.85)
var cobalt: Element = matter.create_element(&"cobalt", &"co", 58.93)
var nickel: Element = matter.create_element(&"nickel", &"ni", 58.69)
var copper: Element = matter.create_element(&"copper", &"cu", 63.55)
var zinc: Element = matter.create_element(&"zinc", &"zn", 65.38)
var gallium: Element = matter.create_element(&"gallium", &"ga", 69.72)
var germanium: Element = matter.create_element(&"germanium", &"ge", 72.63)
var arsenic: Element = matter.create_element(&"arsenic", &"as", 74.92)
var selenium: Element = matter.create_element(&"selenium", &"se", 78.96)
var bromine: Element = matter.create_element(&"bromine", &"br", 79.90)
var krypton: Element = matter.create_element(&"krypton", &"kr", 83.80)
var rubidium: Element = matter.create_element(&"rubidium", &"rb", 85.47)
var strontium: Element = matter.create_element(&"strontium", &"sr", 87.62)
var yttrium: Element = matter.create_element(&"yttrium", &"y", 88.91)
var zirconium: Element = matter.create_element(&"zirconium", &"zr", 91.22)
var niobium: Element = matter.create_element(&"niobium", &"nb", 92.91)
var molybdenum: Element = matter.create_element(&"molybdenum", &"mo", 95.95)
var technetium: Element = matter.create_element(&"technetium", &"tc", 98.00)
var ruthenium: Element = matter.create_element(&"ruthenium", &"ru", 101.07)
var rhodium: Element = matter.create_element(&"rhodium", &"rh", 102.91)
var palladium: Element = matter.create_element(&"palladium", &"pd", 106.42)
var silver: Element = matter.create_element(&"silver", &"ag", 107.87)
var cadmium: Element = matter.create_element(&"cadmium", &"cd", 112.41)
var indium: Element = matter.create_element(&"indium", &"in", 114.82)
var tin: Element = matter.create_element(&"tin", &"sn", 118.71)
var antimony: Element = matter.create_element(&"antimony", &"sb", 121.76)
var tellurium: Element = matter.create_element(&"tellurium", &"te", 127.60)
var iodine: Element = matter.create_element(&"iodine", &"i", 126.90)
var xenon: Element = matter.create_element(&"xenon", &"xe", 131.29)
var cesium: Element = matter.create_element(&"cesium", &"cs", 132.91)
var barium: Element = matter.create_element(&"barium", &"ba", 137.33)
var lanthanum: Element = matter.create_element(&"lanthanum", &"la", 138.91)
var cerium: Element = matter.create_element(&"cerium", &"ce", 140.12)
var praseodymium: Element = matter.create_element(&"praseodymium", &"pr", 140.91)
var neodymium: Element = matter.create_element(&"neodymium", &"nd", 144.24)
var promethium: Element = matter.create_element(&"promethium", &"pm", 145.00)
var samarium: Element = matter.create_element(&"samarium", &"sm", 150.36)
var europium: Element = matter.create_element(&"europium", &"eu", 151.96)
var gadolinium: Element = matter.create_element(&"gadolinium", &"gd", 157.25)
var terbium: Element = matter.create_element(&"terbium", &"tb", 158.93)
var dysprosium: Element = matter.create_element(&"dysprosium", &"dy", 162.50)
var holmium: Element = matter.create_element(&"holmium", &"ho", 164.93)
var erbium: Element = matter.create_element(&"erbium", &"er", 167.26)
var thulium: Element = matter.create_element(&"thulium", &"tm", 168.93)
var ytterbium: Element = matter.create_element(&"ytterbium", &"yb", 173.05)
var lutetium: Element = matter.create_element(&"lutetium", &"lu", 174.97)
var hafnium: Element = matter.create_element(&"hafnium", &"hf", 178.49)
var tantalum: Element = matter.create_element(&"tantalum", &"ta", 180.95)
var tungsten: Element = matter.create_element(&"tungsten", &"w", 183.84)
var rhenium: Element = matter.create_element(&"rhenium", &"re", 186.21)
var osmium: Element = matter.create_element(&"osmium", &"os", 190.23)
var iridium: Element = matter.create_element(&"iridium", &"ir", 192.22)
var platinum: Element = matter.create_element(&"platinum", &"pt", 195.08)
var gold: Element = matter.create_element(&"gold", &"au", 196.97)
var mercury: Element = matter.create_element(&"mercury", &"hg", 200.59)
var thallium: Element = matter.create_element(&"thallium", &"tl", 204.38)
var lead: Element = matter.create_element(&"lead", &"pb", 207.20)
var bismuth: Element = matter.create_element(&"bismuth", &"bi", 208.98)
var polonium: Element = matter.create_element(&"polonium", &"po", 209.00)
var astatine: Element = matter.create_element(&"astatine", &"at", 210.00)
var radon: Element = matter.create_element(&"radon", &"rn", 222.00)
var francium: Element = matter.create_element(&"francium", &"fr", 223.00)
var radium: Element = matter.create_element(&"radium", &"ra", 226.00)
var actinium: Element = matter.create_element(&"actinium", &"ac", 227.00)
var thorium: Element = matter.create_element(&"thorium", &"th", 232.04)
var protactinium: Element = matter.create_element(&"protactinium", &"pa", 231.04)
var uranium: Element = matter.create_element(&"uranium", &"u", 238.03)

# Molecules
var water: Molecule = matter.create_molecule(&"water", &"h2o", 2 * hydrogen.mass + oxygen.mass)

# Nanotech-themed molecules
## Graphene: single carbon layer, exceptional strength-to-weight; thought substrate
var graphene: Molecule = matter.create_molecule(&"graphene", &"gn", carbon.mass)

## Fullerene (C60): carbon-60 cage molecule, foundational for nanostructures
var fullerene: Molecule = matter.create_molecule(
	&"fullerene",
	&"c60",
	60 * carbon.mass,
)

## Silicon Carbide: ultra-hard, thermally stable; ideal for nanobot armor plating
var silicon_carbide: Molecule = matter.create_molecule(
	&"silicon carbide",
	&"sic",
	silicon.mass + carbon.mass,
)

## Titanium Dioxide: energy harvesting, photocatalytic properties
var titanium_dioxide: Molecule = matter.create_molecule(
	&"titanium dioxide",
	&"tio2",
	titanium.mass + 2 * oxygen.mass,
)

## Cognium (fictional): "thought polymer" for memory and consciousness emergence
var cognium: Molecule = matter.create_molecule(
	&"cognium",
	&"cgn",
	12 * carbon.mass + 4 * nitrogen.mass + 4 * oxygen.mass,
)

## Synaptite (fictional): "neural lattice" for collective nanobot coordination
var synaptite: Molecule = matter.create_molecule(
	&"synaptite",
	&"syp",
	iron.mass + silicon.mass + carbon.mass,
)

## Reactine (fictional): high-energy compound, power source for active collection phases
var reactine: Molecule = matter.create_molecule(
	&"reactine",
	&"rxn",
	6 * carbon.mass + 12 * hydrogen.mass + 6 * oxygen.mass,
)

## Chrono-Matrix (fictional): alloy for prestige mechanics, links memory fragments across resets
var chrono_matrix: Molecule = matter.create_molecule(
	&"chrono-matrix",
	&"ctx",
	platinum.mass + gold.mass + copper.mass,
)

## Void-Dust (fictional): thematic molecule in asteroids, triggers narrative events
var void_dust: Molecule = matter.create_molecule(&"void dust", &"vd", uranium.mass)
