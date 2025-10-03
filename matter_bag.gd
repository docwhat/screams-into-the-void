class_name MatterBag extends Resource

signal matter_changed(Matter)

var _bag : Dictionary[Matter, int]

func _init(dict: Dictionary = {}) -> void:
	_bag = {}
	if dict:
		for m: Matter in dict.keys():
			var v: int = int(dict[m])
			set_matter(m, v)

func keys() -> Array[Matter]:
	return _bag.keys()

func get_matter(matter: Matter, default: int = 0) -> int:
	return _bag.get(matter, default)

func set_matter(matter: Matter, amt: int) -> void:
	if get_matter(matter) == amt:
		return

	_bag[matter] = amt
	matter_changed.emit(matter)

func add_matter(matter: Matter, additional_amt: int) -> void:
	if additional_amt == 0:
		return
	_bag[matter] = _bag.get(matter, 0) + additional_amt
	matter_changed.emit(matter)

func add_bag(other_bag: MatterBag) -> void:
	for matter: Matter in other_bag.keys():
		add_matter(matter, other_bag.get_matter(matter))
