@tool
class_name MatterBag
extends Resource

## A signal that is emitted whenever the contents of the bag change.
signal matter_changed(Matter)

## Private dictionary holding the matter amounts.
var _bag: Dictionary[Matter, int]


func _init(dict: Dictionary = { }) -> void:
	_bag = { }
	if dict:
		for m: Matter in dict.keys():
			var v: int = int(dict[m])
			set_by_matter(m, v)


## Returns an array of all Matter types in the bag.
func keys() -> Array[Matter]:
	return _bag.keys()


## Returns a duplicate of this MatterBag, including its contents.
func duplicate_bag() -> MatterBag:
	return MatterBag.new(_bag)


## Replaces the contents of this bag with another bag.
## Use this to prevent losing signal connections.
func replace_bag(other_bag: MatterBag) -> void:
	for matter: Matter in Matter.all_matter:
		var amt: int = other_bag.get_by_matter(matter, 0)
		set_by_matter(matter, amt)


## Given a Matter's name, returns the amount in the bag.
func get_by_name(matter_name: StringName, default: int = 0) -> int:
	var matter: Matter = Matter.by_name.get(matter_name, null)
	if matter == null:
		return default
	return get_by_matter(matter, default)


## Given a Matter's name, sets the amount in the bag.
func set_by_name(matter_name: StringName, amt: int) -> void:
	var matter: Matter = Matter.by_name.get(matter_name, null)
	if matter == null:
		return
	set_by_matter(matter, amt)


## Given a Matter, returns the amount in the bag.
func get_by_matter(matter: Matter, default: int = 0) -> int:
	return _bag.get(matter, default)


## Sets the amount of the given Matter in the bag.
func set_by_matter(matter: Matter, amt: int) -> void:
	if get_by_matter(matter) == amt:
		return

	_bag[matter] = amt
	matter_changed.emit(matter)


## Adds the given amount of Matter to the bag.
func add_by_matter(matter: Matter, additional_amt: int) -> void:
	if additional_amt == 0:
		return
	_bag[matter] = _bag.get(matter, 0) + additional_amt
	matter_changed.emit(matter)


## Adds all the matter from another bag into this one.
func add_bag(other_bag: MatterBag) -> void:
	for matter: Matter in other_bag.keys():
		add_by_matter(matter, other_bag.get_by_matter(matter))
