extends GdUnitTestSuite

## The object under test.
var asteroid_kind: AsteroidKind

@warning_ignore_start("inferred_declaration")
@warning_ignore_start("redundant_await")
@warning_ignore_start("untyped_declaration")


func before_test():
	# Create a test AsteroidKind instance with known parameters
	asteroid_kind = AsteroidKind.new()
	asteroid_kind.name = "TestTest"
	asteroid_kind.probability = 2.0


func after_test():
	auto_free(asteroid_kind)


func test_all_have_required_values():
	for kind: AsteroidKind in AsteroidKind.kinds:
		assert_str(kind.name).has_length(3, Comparator.GREATER_EQUAL)


## Test that _set() works with a valid matter String.
func test_set_matter_by_name():
	asteroid_kind.set("matter/carbon", 23)

	var got: int = asteroid_kind.matter.get_by_name("carbon")
	var expected: int = 23
	assert_int(got).is_equal(expected)


## Test that _set() returns false with an invalid matter String.
func test_set_matter_by_invalid_name():
	asteroid_kind.set("matter_invalid_matter_name", 23)

	var got: int = asteroid_kind.matter.get_by_name("invalid_matter_name")
	var expected: int = 0
	assert_int(got) \
	.append_failure_message("Matter value for invalid name should be 0") \
	.is_equal(expected)


## Test that _get() works with a valid matter String.
func test_get_matter_by_name():
	asteroid_kind.matter.set_by_name("carbon", 42)
	var got: int = asteroid_kind.get("matter/carbon")
	var expected: int = 42
	assert_int(got).is_equal(expected)


## Test that _get() returns null with an invalid matter String.
func test_get_matter_by_invalid_name():
	var got: Variant = asteroid_kind.get("matter_invalid_matter_name")
	assert_object(got).is_null()


## Test that _get_property_list() includes all Matter types.
func test_get_property_list_includes_all_matter_types():
	var props: Array[Dictionary] = asteroid_kind.get_property_list()
	var matter_props: Array[Dictionary] = []
	for prop: Dictionary in props:
		if prop.has("name") and prop["name"].begins_with("matter/"):
			matter_props.append(prop)

	# Check names of each matter property.
	var got_names: Array[String] = []
	for prop: Dictionary in matter_props:
		got_names.append(prop["name"].get_slice("/", 1))
	var expected_names: Array[String] = Global.matter.by_name.keys()

	assert_array(got_names).contains_exactly_in_any_order(expected_names)


## Test that _get_property_list()'s matter properties have "type" keys.
func test_get_property_list_matter_properties_have_type_keys():
	var props: Array[Dictionary] = asteroid_kind.get_property_list()
	for prop: Dictionary in props:
		if prop.has("name") and prop["name"].begins_with("matter/"):
			assert_int(prop.get("type")).is_not_null().is_equal(TYPE_INT)
