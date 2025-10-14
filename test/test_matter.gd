extends GdUnitTestSuite

# We can be more lax in tests.
@warning_ignore_start("inferred_declaration")
@warning_ignore_start("redundant_await")

## Despite the name, this is actually testing Element and Molecule, since Matter is abstract.

var _original_all_matter: Array[Matter]
var _original_by_name: Dictionary[StringName, Matter]
var _original_by_symbol: Dictionary[StringName, Matter]


func before():
	# Save off the original all_matter and lookup dicts, so we can restore them later.
	_original_all_matter = Matter.all_matter.duplicate()
	_original_by_name = Matter.by_name.duplicate()
	_original_by_symbol = Matter.by_symbol.duplicate()


func after_test():
	# Restore the original all_matter and lookup dicts, so other tests aren't affected.
	Matter.all_matter = _original_all_matter.duplicate()
	Matter.by_name = _original_by_name.duplicate()
	Matter.by_symbol = _original_by_symbol.duplicate()


## Test that the Element constructor works.
func test_element_init():
	var e := Element.new("test", "T", 1.23)
	assert_str(e.name).is_equal("test")
	assert_str(e.symbol).is_equal("t")
	assert_float(e.mass).is_equal(1.23)


## Test that the Molecule constructor works.
func test_molecule_init():
	var m := Molecule.new("test_molecule", "TM", 4.56)
	assert_str(m.name).is_equal("test_molecule")
	assert_str(m.symbol).is_equal("tm")
	assert_float(m.mass).is_equal(4.56)


## Test that all_matter are populated correctly.
func test_all_matter():
	# There should be at least be a few elements and a water molecule.
	assert_array(Matter.all_matter).contains(Matter.carbon)
	assert_array(Matter.all_matter).contains(Matter.hydrogen)
	assert_array(Matter.all_matter).contains(Matter.oxygen)
	assert_array(Matter.all_matter).contains(Matter.water)


## Test that by_name is populated correctly.
func test_by_name():
	# There should be at least be a few elements and a water molecule.
	assert_array(Matter.by_name.keys()).contains("carbon")
	assert_array(Matter.by_name.keys()).contains("hydrogen")
	assert_array(Matter.by_name.keys()).contains("oxygen")
	assert_array(Matter.by_name.keys()).contains("water")

	assert_object(Matter.by_name["carbon"]).is_equal(Matter.carbon)
	assert_object(Matter.by_name["hydrogen"]).is_equal(Matter.hydrogen)
	assert_object(Matter.by_name["oxygen"]).is_equal(Matter.oxygen)
	assert_object(Matter.by_name["water"]).is_equal(Matter.water)


## Test that by_symbol is populated correctly.
func test_by_symbol():
	# There should be at least be a few elements and a water molecule.
	assert_array(Matter.by_symbol.keys()).contains("c")
	assert_array(Matter.by_symbol.keys()).contains("h")
	assert_array(Matter.by_symbol.keys()).contains("o")
	assert_array(Matter.by_symbol.keys()).contains("h2o")

	assert_object(Matter.by_symbol["c"]).is_equal(Matter.carbon)
	assert_object(Matter.by_symbol["h"]).is_equal(Matter.hydrogen)
	assert_object(Matter.by_symbol["o"]).is_equal(Matter.oxygen)
	assert_object(Matter.by_symbol["h2o"]).is_equal(Matter.water)


## Test that preferred_name works.
func test_preferred_name():
	GameSave.use_symbols = false
	assert_str(Matter.carbon.preferred_name).is_equal("carbon")
	GameSave.use_symbols = true
	assert_str(Matter.carbon.preferred_name).is_equal("c")


## Verify that you can't create two elements with the same name.
func test_element_name_is_unique():
	var e1 := Element.new(&"uniqueium", &"ue", 10.0)

	await assert_error(
		func(): Element.new(&"uniqueium", &"ue2", 20.0)
	).is_push_error('Duplicate Matter name: uniqueium')

	# Lookup should return the original element.
	assert_object(Matter.by_name[&"uniqueium"]).is_equal(e1)


## Verify that you can't create two elements with the same symbol.
func test_element_symbol_is_unique():
	var e1 := Element.new(&"anotherium", &"an", 10.0)

	await assert_error(
		func(): Element.new(&"anotherium2", &"an", 20.0)
	).is_push_error('Duplicate Matter symbol: an')

	# Lookup should return the original element.
	assert_object(Matter.by_symbol[&"an"]).is_equal(e1)
