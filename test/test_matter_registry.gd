extends GdUnitTestSuite

# We can be more lax in tests.
@warning_ignore_start("inferred_declaration")
@warning_ignore_start("untyped_declaration")

var registry: MatterRegistry


func before_test():
	registry = MatterRegistry.new()


## Test that we can add and retrieve Matter instances in the registry.
func test_can_add_matter():
	var element = Element.new("Testium", "Ts", 123.45)
	registry.add(element)
	assert_array(registry.all).contains_exactly(element)


## Test that getting non-existent Matter returns null.
func test_get_by_name_not_found():
	assert_object(registry.get_by_name("NonExistent")).is_null()


## Test that getting non-existent Matter by symbol returns null.
func test_get_by_symbol_not_found():
	assert_object(registry.get_by_symbol("Nx")).is_null()


## Test that name lookups are case-insensitive.
func test_get_by_name_case_insensitive():
	var element = registry.create_element("CaseTestium", "Ct", 67.89)
	assert_object(registry.get_by_name("casetestium")).is_equal(element)
	assert_object(registry.get_by_name("CASETESTIUM")).is_equal(element)


## Test that symbol lookups are case-insensitive.
func test_get_by_symbol_case_insensitive():
	var element = registry.create_element("SymbolTestium", "St", 45.67)
	assert_object(registry.get_by_symbol("st")).is_equal(element)
	assert_object(registry.get_by_symbol("ST")).is_equal(element)

## All by_name keys are lowercase.
func test_by_name_keys_lowercase():
	registry.create_element("LowerCaseTestium", "Lct", 10.11)
	for key in registry.by_name.keys():
		assert_str(key).is_equal(key.to_lower())

## All by_symbol keys are lowercase.
func test_by_symbol_keys_lowercase():
	registry.create_element("LowerSymbolTestium", "Lst", 12.13)
	for key in registry.by_symbol.keys():
		assert_str(key).is_equal(key.to_lower())

## Test that you can't add a duplicate name.
func test_add_duplicate_name_fails():
	var element1 = Element.new("Duplicateium", "Du", 12.34)
	var element2 = Element.new("Duplicateium", "Dv", 56.78)
	assert_bool(registry.add(element1)).is_true()
	assert_bool(registry.add(element2)).is_false()

	# Lookup should return the first added element.
	assert_object(registry.get_by_name("Duplicateium")).is_equal(element1)
	assert_object(registry.get_by_symbol("Du")).is_equal(element1)
	assert_array(registry.all).not_contains(element2)


## Test that you can't add a duplicate symbol.
func test_add_duplicate_symbol_fails():
	var element1 = Element.new("UniqueName1", "DupSym", 12.34)
	var element2 = Element.new("UniqueName2", "DupSym", 56.78)
	assert_bool(registry.add(element1)).is_true()
	assert_bool(registry.add(element2)).is_false()
	
	# Lookup should return the first added element.
	assert_object(registry.get_by_symbol("DupSym")).is_equal(element1)
	assert_object(registry.get_by_name("UniqueName1")).is_equal(element1)
	assert_array(registry.all).not_contains(element2)

# EOF
