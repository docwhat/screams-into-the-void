extends GdUnitTestSuite

## A MatterBag for using in tests.
var bag: MatterBag

## This is set to true if the matter_changed signal is emitted for bag.
var changed: bool = false


func before_test():
	bag = MatterBag.new()
	bag.matter_changed.connect(
		func(_m: Matter) -> void:
			changed = true
	)


func after_test():
	auto_free(bag)


## Test that the constructor handles an empty dictionary correctly.
func test_constructor_with_empty_dictionary():
	var dict = { }
	bag = MatterBag.new(dict)
	for matter: Matter in Matter.all_matter:
		var got: int = bag.get_by_matter(matter)
		var expected: int = 0
		assert_int(got).is_equal(expected)


## Test that the constructor handles a populated, untyped dictionary correctly.
func test_constructor_with_dictionary():
	var dict = {
		Matter.carbon: 2,
		Matter.water: 3,
	}
	bag = MatterBag.new(dict)
	for matter: Matter in Matter.all_matter:
		var got: int = bag.get_by_matter(matter)
		var expected: int = dict.get(matter, 0)
		assert_int(got).is_equal(expected)
		if is_failure():
			return


## Test that the constructor handles a populated, typed dictionary correctly.
func test_constructor_with_typed_dictionary():
	var dict: Dictionary[Matter, int] = {
		Matter.carbon: 2,
		Matter.water: 3,
	}
	bag = MatterBag.new(dict)
	for matter: Matter in Matter.all_matter:
		var got: int = bag.get_by_matter(matter)
		var expected: int = dict.get(matter, 0)
		assert_int(got).is_equal(expected)
		if is_failure():
			return


## Test that set_matter() works.
func test_can_set_matter():
	bag.set_by_matter(Matter.carbon, 23)
	var got: int = bag.get_by_matter(Matter.carbon)
	var expected: int = 23
	assert_int(got).is_equal(expected)


## Test that set_matter() accepts zero.
func test_can_set_matter_to_zero():
	assert_int(bag.get_by_matter(Matter.helium)).is_equal(0)
	bag.set_by_matter(Matter.helium, 23)
	assert_int(bag.get_by_matter(Matter.helium)).is_equal(23)


## Setting matter to the same value should not emit the changed signal.
func test_set_matter_no_op():
	bag.set_by_matter(Matter.oxygen, 5)
	changed = false
	bag.set_by_matter(Matter.oxygen, 5)
	assert_bool(changed).is_false()


## Setting matter to a different value should emit the changed signal.
func test_set_matter_emit_signal():
	bag.set_by_matter(Matter.oxygen, 5)
	changed = false
	bag.set_by_matter(Matter.oxygen, 6)
	assert_bool(changed).is_true()


## Adding zero matter should not emit the changed signal.
func test_add_matter_should_not_emit_signal():
	bag.set_by_matter(Matter.hydrogen, 10)
	changed = false
	bag.add_by_matter(Matter.hydrogen, 0)
	assert_bool(changed).is_false()


## Adding non-zero matter should emit the changed signal.
func test_add_matter_emit_signal():
	bag.add_by_matter(Matter.hydrogen, 200)
	assert_bool(changed).is_true()


## Check that .duplicate_bag() copies the contents.
func test_duplicate_bag():
	bag.set_by_matter(Matter.carbon, 2)
	bag.set_by_matter(Matter.water, 3)

	var bag2: MatterBag = bag.duplicate_bag()

	for matter: Matter in Matter.all_matter:
		var got: int = bag2.get_by_matter(matter)
		var expected: int = bag.get_by_matter(matter)
		assert_int(got).append_failure_message("for %s" % matter.name).is_equal(expected)
		if is_failure():
			return


## Using set_by_name() with a matter StringName should set the matching amount.
func test_set_by_name():
	for mat: Matter in Matter.all_matter:
		var expected: int = randi_range(0, 100)
		bag.set_by_name(mat.name, expected)
		assert_int(bag.get_by_matter(mat)).is_equal(expected)
		if is_failure():
			return


## set_by_name() with an invalid name should do nothing.
func test_set_by_name_invalid():
	# Populate the bag with some random values.
	for mat: Matter in Matter.all_matter:
		bag.set_by_matter(mat, randi_range(1, 100))

	# Make a copy of the original bag.
	var original_bag = bag.duplicate_bag()

	# Now try to set a non-existent matter.
	bag.set_by_name("not_a_real_matter", 42)

	# The bag should be unchanged.
	for mat: Matter in Matter.all_matter:
		assert_int(bag.get_by_matter(mat)) \
		.append_failure_message("for %s" % mat.name) \
		.is_equal(original_bag.get_by_matter(mat))


## set_by_name() with a new value should emit the changed signal.
func test_set_by_name_emit_signal():
	changed = false
	bag.set_by_name(Matter.helium.name, 77)
	assert_bool(changed).is_true()


## set_by_name() with the same value should not emit the changed signal.
func test_set_by_name_no_op():
	bag.set_by_matter(Matter.helium, 22)
	changed = false
	bag.set_by_name(Matter.helium.name, 22)
	assert_bool(changed).is_false()


## set_by_name() with an invalid name should not emit the changed signal.
func test_set_by_name_invalid_no_op():
	changed = false
	bag.set_by_name("not_a_real_matter", 42)
	assert_bool(changed).is_false()


## Using get_by_name() with a matter StringName should retrieve the matching amount.
func test_get_by_name():
	for mat: Matter in Matter.all_matter:
		var expected: int = randi_range(0, 100)
		bag.set_by_matter(mat, expected)

		var got: int = bag.get_by_name(mat.name)
		assert_int(got).is_equal(expected)
		if is_failure():
			return


## Adding matter should increase the amount correctly.
func test_add_matter():
	bag.set_by_matter(Matter.hydrogen, 10)
	bag.add_by_matter(Matter.hydrogen, 42)
	var got: int = bag.get_by_matter(Matter.hydrogen)
	assert_int(got).is_equal(52)


## Adding negative matter should decrease the amount correctly.
func test_add_negative_matter():
	bag.set_by_matter(Matter.hydrogen, 50)
	bag.add_by_matter(Matter.hydrogen, -20)
	var got: int = bag.get_by_matter(Matter.hydrogen)
	assert_int(got).is_equal(30)


## Adding the contents of another bag should work correctly.
func test_add_bag():
	var bag2: MatterBag = MatterBag.new()

	bag.set_by_matter(Matter.carbon, 2)
	bag.set_by_matter(Matter.magnesium, 3)

	bag2.set_by_matter(Matter.carbon, 11)
	bag2.set_by_matter(Matter.water, 23)

	bag.add_bag(bag2)

	assert_int(bag.get_by_matter(Matter.carbon)).is_equal(13)

	assert_int(bag.get_by_matter(Matter.magnesium)).is_equal(3)

	assert_int(bag.get_by_matter(Matter.water)).is_equal(23)
