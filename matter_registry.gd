class_name MatterRegistry
extends Resource

var all: Array[Matter]
var by_name: Dictionary[String, Matter]
var by_symbol: Dictionary[String, Matter]


func _init() -> void:
	all = []
	by_name = { }
	by_symbol = { }


## Wrapper around Element.new
func create_element(...args: Array) -> Element:
	var element: Element = Element.new.callv(args)
	if add(element):
		return element
	return null


## Wrapper around Molecule.new
func create_molecule(...args: Array) -> Molecule:
	var molecule: Molecule = Molecule.new.callv(args)
	if add(molecule):
		return molecule
	return null


## Registers a Matter instance into the registry.
func add(matter: Matter) -> bool:
	var name: String = matter.name.to_lower()
	var symbol: String = matter.symbol.to_lower()

	if by_name.has(name):
		return false
	if by_symbol.has(symbol):
		return false

	all.append(matter)
	by_name[name] = matter
	by_symbol[symbol] = matter

	return true


## Find matter by name.
func get_by_name(name: String) -> Matter:
	return by_name.get(name.to_lower())


## Find matter by symbol.
func get_by_symbol(symbol: String) -> Matter:
	return by_symbol.get(symbol.to_lower())


## Check if name exists.
func has_name(name: String) -> bool:
	return by_name.has(name.to_lower())


## Check if symbol exists.
func has_symbol(symbol: String) -> bool:
	return by_symbol.has(symbol.to_lower())
