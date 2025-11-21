extends GdUnitTestSuite

# We can be more lax in tests.
@warning_ignore_start("inferred_declaration")
@warning_ignore_start("redundant_await")
@warning_ignore_start("untyped_declaration")

## Test that the Element constructor works.
func test_element_init():
	var e := Element.new("testium", "T", 1.23)
	assert_str(e.name).is_equal("testium")
	assert_str(e.symbol).is_equal("t")
	assert_float(e.mass).is_equal(1.23)


## Test that preferred_name works.
func test_preferred_name():
	GameSave.use_symbols = false
	assert_str(AllMatter.carbon.preferred_name).is_equal("carbon")
	GameSave.use_symbols = true
	assert_str(AllMatter.carbon.preferred_name).is_equal("c")


## Test that element names and symbols are capitalized.
func test_element_name_symbol_capitalization():
	var e := Element.new("sodium", "na", 22.99)
	assert_str(e.name).is_equal("sodium")
	assert_str(e.symbol).is_equal("na")
