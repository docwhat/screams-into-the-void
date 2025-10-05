extends GdUnitTestSuite

var bag1: MatterBag
var bag2: MatterBag


func before_test():
	bag1 = MatterBag.new()
	bag2 = MatterBag.new()


func after_test():
	auto_free(bag1)
	auto_free(bag2)


func test_constructor_with_empty_dictionary():
	var dict = { }
	bag1 = MatterBag.new(dict)
	for matter: Matter in Matter.all_matter:
		var got: int = bag1.get_matter(matter)
		var expected: int = 0
		assert_int(got).is_equal(expected)


func test_constructor_with_dictionary():
	var dict = {
		Matter.carbon: 2,
		Matter.water: 3,
	}
	bag1 = MatterBag.new(dict)
	for matter: Matter in Matter.all_matter:
		var got: int = bag1.get_matter(matter)
		var expected: int = dict.get(matter, 0)
		assert_int(got).is_equal(expected)


func test_constructor_with_typed_dictionary():
	var dict: Dictionary[Matter, int] = {
		Matter.carbon: 2,
		Matter.water: 3,
	}
	bag1 = MatterBag.new(dict)
	for matter: Matter in Matter.all_matter:
		var got: int = bag1.get_matter(matter)
		var expected: int = dict.get(matter, 0)
		assert_int(got).is_equal(expected)


func test_can_set_matter():
	bag1.set_matter(Matter.carbon, 23)
	var got: int = bag1.get_matter(Matter.carbon)
	var expected: int = 23
	assert_int(got).is_equal(expected)


func test_can_set_matter_to_zero():
	assert_int(bag1.get_matter(Matter.helium)).is_equal(0)
	bag1.set_matter(Matter.helium, 23)
	assert_int(bag1.get_matter(Matter.helium)).is_equal(23)


func test_add_matter():
	bag1.set_matter(Matter.hydrogen, 10)
	bag1.add_matter(Matter.hydrogen, 42)
	assert_int(bag1.get_matter(Matter.hydrogen)).is_equal(52)


func test_add_bag():
	bag1.set_matter(Matter.carbon, 2)
	bag1.set_matter(Matter.magnesium, 3)

	bag2.set_matter(Matter.carbon, 11)
	bag2.set_matter(Matter.water, 23)

	bag1.add_bag(bag2)

	assert_int(bag1.get_matter(Matter.carbon)).is_equal(13)

	assert_int(bag1.get_matter(Matter.magnesium)).is_equal(3)

	assert_int(bag1.get_matter(Matter.water)).is_equal(23)
