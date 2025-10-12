extends GdUnitTestSuite

# We can be more lax in tests.
@warning_ignore_start("inferred_declaration")

## Despite the name, this is actually testing Element and Molecule, since Matter is abstract.

var _original_all_matter: Array[Matter]
var _original_lookup: Dictionary[StringName, Matter]


func before():
	# Save off the original all_matter and lookup, so we can restore them later.
	_original_all_matter = Matter.all_matter.duplicate()
	_original_lookup = Matter.lookup.duplicate()


func after_test():
	# Restore the original all_matter and lookup, so other tests aren't affected.
	Matter.all_matter = _original_all_matter.duplicate()
	Matter.lookup = _original_lookup.duplicate()


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


## Test that lookup is populated correctly.
func test_lookup():
	# There should be at least be a few elements and a water molecule.
	assert_array(Matter.lookup.keys()).contains("carbon")
	assert_array(Matter.lookup.keys()).contains("hydrogen")
	assert_array(Matter.lookup.keys()).contains("oxygen")
	assert_array(Matter.lookup.keys()).contains("water")

	assert_object(Matter.lookup["carbon"]).is_equal(Matter.carbon)
	assert_object(Matter.lookup["hydrogen"]).is_equal(Matter.hydrogen)
	assert_object(Matter.lookup["oxygen"]).is_equal(Matter.oxygen)
	assert_object(Matter.lookup["water"]).is_equal(Matter.water)


## Test that preferred_name works.
func test_preferred_name():
	State.use_symbols = false
	assert_str(Matter.carbon.preferred_name).is_equal("carbon")
	State.use_symbols = true
	assert_str(Matter.carbon.preferred_name).is_equal("c")
