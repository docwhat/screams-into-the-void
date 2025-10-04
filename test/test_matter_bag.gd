class_name TestMatterBag
extends GutTest

var bag1: MatterBag
var bag2: MatterBag


func before_each():
	bag1 = MatterBag.new()
	bag2 = MatterBag.new()


func after_each():
	autofree(bag1)
	autofree(bag2)


func test_constructor_with_empty_dictionary():
	var dict = { }
	bag1 = MatterBag.new(dict)
	for matter: Matter in Matter.all_matter:
		assert_eq(bag1.get_matter(matter), 0)


func test_constructor_with_dictionary():
	var dict = {
		Matter.carbon: 2,
		Matter.water: 3,
	}
	bag1 = MatterBag.new(dict)
	for matter: Matter in Matter.all_matter:
		assert_eq(bag1.get_matter(matter), dict.get(matter, 0))


func test_constructor_with_typed_dictionary():
	var dict: Dictionary[Matter, int] = {
		Matter.carbon: 2,
		Matter.water: 3,
	}
	bag1 = MatterBag.new(dict)
	for matter: Matter in Matter.all_matter:
		assert_eq(bag1.get_matter(matter), dict.get(matter, 0))


func test_can_set_matter():
	bag1.set_matter(Matter.carbon, 23)
	assert_eq(bag1.get_matter(Matter.carbon), 23)


func test_can_set_matter_to_zero():
	assert_eq(bag1.get_matter(Matter.helium), 0)
	bag1.set_matter(Matter.helium, 23)
	assert_eq(bag1.get_matter(Matter.helium), 23)


func test_add_matter():
	bag1.set_matter(Matter.hydrogen, 10)
	bag1.add_matter(Matter.hydrogen, 42)
	assert_eq(bag1.get_matter(Matter.hydrogen), 52)


func test_add_bag():
	bag1.set_matter(Matter.carbon, 2)
	bag1.set_matter(Matter.magnesium, 3)
	bag2.set_matter(Matter.carbon, 5)
	bag2.set_matter(Matter.water, 7)

	bag1.add_bag(bag2)

	assert_eq(bag1.get_matter(Matter.carbon), 7)
	assert_eq(bag1.get_matter(Matter.magnesium), 3)
	assert_eq(bag1.get_matter(Matter.water), 7)
