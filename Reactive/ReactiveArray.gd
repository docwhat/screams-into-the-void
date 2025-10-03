class_name ReactiveArray extends Reactive

func _init(initial_value: Array[Reactive] = [], parent_ : Reactive = null) -> void:
	super._init(parent_)
	value = initial_value

# Sets the underlying array. This differs from assign() since this
# replaces the array stored in ReactiveArray without modifying the old
# value.
#
# This is mainly used internally.
var value: Array[Reactive]:
	set(v):
		value = v
		for r : Reactive in v:
			r.parent = self
		reactive_changed.emit(self)
		return value

# The equivalent of the [] operator.
func get_at(i: int) -> Reactive:
	return value[i]

# The equivalent of the []= operator.
func set_at(i: int, v: Reactive) -> void:
	value[i] = v
	v.parent = self
	reactive_changed.emit(self)

#########################
## Forwarding delegations
# Appends value at the end of the array (alias of push_back()).
func append(v: Reactive) -> void:
	push_back(v)

# Appends another array at the end of this array.
func append_array(array: Array) -> void:
	assert(false, "ReactiveArray.append_array() is missing parent assignment")
	value.append_array(array)
	reactive_changed.emit(self)

# Assigns elements of another array into the array. Resizes the array to match array. Performs type conversions if the array is typed.
func assign(array: Array) -> void:
	assert(false, "ReactiveArray.append_array() is missing parent assignment")
	value.assign(array)
	reactive_changed.emit(self)

# Removes all elements from the array. This is equivalent to using resize() with a size of 0.
func clear() -> void:
	assert(false, "ReactiveArray.append_array() is missing parent unassignment")
	value.clear()
	reactive_changed.emit(self)

# Finds and removes the first occurrence of value from the array.
func erase(v: Reactive) -> void:
	assert(false, "ReactiveArray.append_array() is missing parent unassignment")
	value.erase(v)
	reactive_changed.emit(self)

# Assigns the given value to all elements in the array.
func fill(v: Reactive) -> void:
	value.fill(v)
	v.parent = self
	reactive_changed.emit(self)

# Inserts a new element (value) at a given index (position) in the array.
# position should be between 0 and the array's size(). If negative, position is
# considered relative to the end of the array.
func insert(position: int, v: Reactive) -> int:
	var err: int = value.insert(position, v)
	if err == OK:
		v.parent = self
		reactive_changed.emit(self)
	return err

# Removes and returns the element of the array at index position. If negative,
# position is considered relative to the end of the array. Returns null if the
# array is empty. If position is out of bounds, an error message is also
# generated.
func pop_at(index: int) -> Reactive:
	var tmp = value.pop_at(index)
	tmp.parent = null
	reactive_changed.emit(self)
	return tmp

# Removes and returns the last element of the array. Returns null if the array
# is empty, without generating an error.
func pop_back() -> Reactive:
	var tmp = value.pop_back()
	tmp.parent = null
	reactive_changed.emit(self)
	return tmp

# Removes and returns the first element of the array. Returns null if the array
# is empty, without generating an error.
func pop_front() -> Reactive:
	var tmp = value.pop_front()
	tmp.parent = null
	reactive_changed.emit(self)
	return tmp

# Appends an element at the end of the array.
func push_back(v: Reactive) -> void:
	value.push_back(v)
	v.parent = self
	reactive_changed.emit(self)

# Removes the element from the array at the given index (position). If the index
# is out of bounds, this method fails. If the index is negative, position is
# considered relative to the end of the array.
func remove_at(index: int) -> void:
	value.remove_at(index)
	reactive_changed.emit(self)

# Sets the array's number of elements to size. If size is smaller than the
# array's current size, the elements at the end are removed. If size is greater,
# new default elements (usually null) are added, depending on the array's type.
func resize(s: int) -> int:
	var err: int = value.resize(s)
	if err == OK:
		reactive_changed.emit(self)
	return err

# Shuffles all elements of the array in a random order.
func shuffle() -> void:
	value.shuffle()
	reactive_changed.emit(self)

# Returns the number of elements in the array. Empty arrays ([]) always return
# 0. See also is_empty().
func size() -> int:
	return value.size()

# Sorts the array in ascending order. The final order is dependent on the "less
# than" (<) comparison between elements.
func sort() -> void:
	value.sort()
	reactive_changed.emit(self)

# Sorts the array using a custom Callable.
func sort_custom(callable: Callable) -> void:
	value.sort_custom(callable)
	reactive_changed.emit(self)
