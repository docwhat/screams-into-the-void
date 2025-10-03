class_name ReactiveDictionary extends Reactive

func _init(initial_value: Dictionary[Variant, Reactive] = {}, parent_ : Reactive = null) -> void:
	super._init(parent_)
	value = initial_value

# Sets the underlying dictionary. This differs from assign() since this
# replaces the dictionary stored in ReactiveDictionary without modifying the old
# value.
var value: Dictionary[Variant, Reactive]:
	set(v):
		value = v
		for r : Reactive in v.values():
			r.parent = self
		reactive_changed.emit(self)
		return value

# The equivalent of the [] operator.
func get_by_key(key: Variant, default: Reactive = null) -> Reactive:
	return value.get(key, default)

# The equivalent of the []= operator.
func set_by_key(key: Variant, new_value: Reactive) -> void:
	var old_value : Reactive = value.get(key, null)
	if old_value is Reactive:
		old_value.parent = null

	value[key] = new_value
	new_value.parent = self
	reactive_changed.emit(self)

#########################
## Forwarding delegations

# Clears the dictionary of all key-value pairs.
func clear() -> void:
	# Disconnect any Reactive values from this dictionary.
	for key in value.keys():
		if value[key] is Reactive:
			value[key].parent = null

	value.clear()
	reactive_changed.emit(self)

# Erases the key-value pair identified by key from the dictionary.
func erase(key: Reactive) -> void:
	if not value.has(key):
		return

	# Disconnect the Reactive value.
	if value[key] is Reactive:
		value[key].parent = null

	value.erase(key)
	reactive_changed.emit(self)

# Gets a value and ensures the key is non-null. If the key exists in the
# dictionary and it isn't null, then behaves like get_by_key(). Otherwise, the default
# value is inserted into the dictionary and returned.
func get_or_add(key : Variant, default : Reactive) -> Reactive:
		var val : Reactive = get_by_key(key, null)
		if val == null:
		set_by_key(key, default)
		return default
		else:
		return val

# Returns the list of keys in the dictionary.
func keys() -> Array[Variant]:
	return value.keys()

# Returns the list of values in this dictionary.
func values() -> Array[Reactive]:
	return value.values()

# EOF
