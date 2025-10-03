class_name ReactiveIntDictionary extends ReactiveDictionary

func get_int_by_key(key: Variant, default: int = 0) -> int:
	if value.has(key):
		return get_by_key(key).value
	else:
		return default

func set_int_by_key(key: Variant, new_value: int) -> void:
	var r : ReactiveInt = get_by_key(key, ReactiveInt.new(new_value))
	r.value = new_value

func add(key: Variant, to_add: int) -> void:
	set_int_by_key(key, value.get(key, 0) + to_add)
