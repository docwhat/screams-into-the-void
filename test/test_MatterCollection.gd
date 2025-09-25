extends GutTest

# Test file for MatterCollection class
class_name TestMatterCollection

var matter_collection: MatterCollection
var other_collection: MatterCollection

const Matter = MatterCollection.Matter

func before_all():
  # Display the current seed.
  print("Current seed: %d" % Global.rng.seed)
  print("----------------------------------")

func before_each():
  # Create fresh MatterCollection instances for each test
  matter_collection = MatterCollection.new()
  other_collection = MatterCollection.new()

func after_each():
  autofree(matter_collection)
  autofree(other_collection)

# Test initialization and clear functionality
func test_init_clears_all_matter_to_zero():
  for matter_type in Matter.values():
    assert_eq(matter_collection.get_amount(matter_type), 0,
      "Matter type %s should be initialized to 0.0" % [matter_type])

func test_clear_resets_all_matter_to_zero():
  # Set some values first
  matter_collection.set_amount(Matter.CARBON, 10)
  matter_collection.set_amount(Matter.WATER, 5)

  # Clear and verify all are zero
  matter_collection.clear()

  for matter_type in Matter.values():
    assert_eq(matter_collection.get_amount(matter_type), 0,
      "Matter type %s should be cleared to 0" % [matter_type])

# Test get_amount functionality
func test_get_amount_returns_correct_value():
  matter_collection.set_amount(Matter.CARBON, 15)
  assert_eq(matter_collection.get_amount(Matter.CARBON), 15,
    "get_amount should return the exact value stored")

func test_get_amount_different_matter_types():
  matter_collection.set_amount(Matter.WATER, 7)
  matter_collection.set_amount(Matter.IRON, 12)

  assert_eq(matter_collection.get_amount(Matter.WATER), 7)
  assert_eq(matter_collection.get_amount(Matter.IRON), 12)
  assert_eq(matter_collection.get_amount(Matter.CARBON), 0)

func test_getter():
  matter_collection.carbon = 23
  assert_eq(matter_collection.get_by_string("CARBON"), 23)

# Test set_amount functionality
func test_set_amount_positive_value():
  matter_collection.set_amount(Matter.SILICON, 25)
  assert_eq(matter_collection.get_amount(Matter.SILICON), 25,
    "set_amount should set the exact positive value")

func test_set_amount_zero_value():
  matter_collection.set_amount(Matter.COPPER, 0)
  assert_eq(matter_collection.get_amount(Matter.COPPER), 0,
    "set_amount should handle zero values")

func test_set_amount_negative_numbers_are_not_allowed():
  matter_collection.set_amount(Matter.URANIUM, -15)
  assert_eq(matter_collection.get_amount(Matter.URANIUM), 0)

func test_set_amount_overwrites_existing():
  matter_collection.set_amount(Matter.CARBON, 10)
  matter_collection.set_amount(Matter.CARBON, 20)
  assert_eq(matter_collection.get_amount(Matter.CARBON), 20,
    "set_amount should overwrite existing values")

func test_setter():
  matter_collection.copper = 10
  assert_eq(matter_collection.get_amount(Matter.COPPER), 10)

# Test incr_amount functionality
func test_add_amount_to_zero():
  matter_collection.incr_amount(Matter.WATER, 5)
  assert_eq(matter_collection.get_amount(Matter.WATER), 5,
    "incr_amount should add to zero base value")

func test_add_amount_to_existing():
  matter_collection.set_amount(Matter.IRON, 10)
  matter_collection.incr_amount(Matter.IRON, 7)
  assert_eq(matter_collection.get_amount(Matter.IRON), 17,
    "incr_amount should add to existing value")

func test_add_amount_with_negative():
  matter_collection.set_amount(Matter.SILICON, 20)
  matter_collection.incr_amount(Matter.SILICON, -5)
  assert_eq(matter_collection.get_amount(Matter.SILICON), 15,
    "incr_amount should handle negative additions")

func test_add_amount_will_zero_on_underflow():
  matter_collection.set_amount(Matter.COPPER, 3)
  matter_collection.incr_amount(Matter.COPPER, -5)
  assert_eq(matter_collection.get_amount(Matter.COPPER), 0,
    "incr_amount should not allow negative results, clamping to 0")

func test_add_amount_add_nothing():
  matter_collection.set_amount(Matter.URANIUM, 8)
  matter_collection.incr_amount(Matter.URANIUM, 0)
  assert_eq(matter_collection.get_amount(Matter.URANIUM), 8,
    "incr_amount with zero should not change the value")

# Test decr_amount functionality
func test_remove_amount_from_existing():
  matter_collection.set_amount(Matter.CARBON, 15)
  matter_collection.decr_amount(Matter.CARBON, 5)
  assert_eq(matter_collection.get_amount(Matter.CARBON), 10,
    "decr_amount should subtract from existing value")

func test_remove_amount_exact_amount():
  matter_collection.set_amount(Matter.WATER, 7)
  matter_collection.decr_amount(Matter.WATER, 7)
  assert_eq(matter_collection.get_amount(Matter.WATER), 0,
    "decr_amount should handle removing exact amount")

func test_remove_amount_more_than_available():
  matter_collection.set_amount(Matter.SILICON, 3)
  matter_collection.decr_amount(Matter.SILICON, 10)
  assert_eq(matter_collection.get_amount(Matter.SILICON), 0,
    "decr_amount should not allow negative results, clamping to 0")

func test_remove_amount_from_zero():
  matter_collection.decr_amount(Matter.IRON, 5)
  assert_eq(matter_collection.get_amount(Matter.IRON), 0,
    "decr_amount from zero should remain zero")

func test_remove_amount_negative_value():
  matter_collection.set_amount(Matter.COPPER, 10)
  matter_collection.decr_amount(Matter.COPPER, -3)
  assert_eq(matter_collection.get_amount(Matter.COPPER), 13,
    "decr_amount with negative value should add to the amount")

# Test add_collection functionality
func test_add_collection_empty_to_empty():
  matter_collection.add_collection(other_collection)

  for matter_type in Matter.values():
    assert_eq(matter_collection.get_amount(matter_type), 0,
      "Adding empty collection to empty should remain zero")

func test_add_collection_empty_to_non_empty():
  matter_collection.set_amount(Matter.SILICON, 5)
  other_collection.set_amount(Matter.SILICON, 3)
  matter_collection.add_collection(other_collection)
  assert_eq(matter_collection.get_amount(Matter.SILICON), 8,
    "Adding empty collection to non-empty should add the amounts")

func test_add_collection_non_empty_to_empty():
  matter_collection.set_amount(Matter.SILICON, 5)
  other_collection.set_amount(Matter.SILICON, 3)
  matter_collection.add_collection(other_collection)
  assert_eq(matter_collection.get_amount(Matter.SILICON), 8,
    "Adding non-empty collection to empty should add the amounts")

func test_add_collection_non_empty_to_non_empty():
  matter_collection.set_amount(Matter.SILICON, 5)
  other_collection.set_amount(Matter.SILICON, 3)
  matter_collection.add_collection(other_collection)
  assert_eq(matter_collection.get_amount(Matter.SILICON), 8,
    "Adding non-empty collection to non-empty should add the amounts")

# Test fill functionality
func test_fill_works():
  matter_collection.fill(23)
  for matter in Matter.values():
    assert_eq(matter_collection.get_amount(matter), 23,
      "fill() should set all amounts to the given value")

func test_fill_negative_value():
  matter_collection.fill(-5)
  for matter in Matter.values():
    var got : int = matter_collection.get_amount(matter)
    var expected : int = 0
    assert_eq(got, expected, "fill() with negative should set all to %d, got %d" % [expected, got])

func test_add_collection():
  matter_collection.set_amount(Matter.WATER, 10)
  other_collection.set_amount(Matter.WATER, 5)
  other_collection.set_amount(Matter.IRON, 3)

  matter_collection.add_collection(other_collection)

  assert_eq(matter_collection.get_amount(Matter.WATER), 15,
    "After adding collections, WATER should be summed correctly")
  assert_eq(matter_collection.get_amount(Matter.IRON), 3,
    "After adding collections, IRON should be added correctly")
  assert_eq(matter_collection.get_amount(Matter.CARBON), 0,
    "After adding collections, CARBON should remain zero if not present")

func test_callback_for_set_amount():
  var data = {
    called = false,
    changed_matters = []
  }

  var callback = func(matter_list):
      data.called = true
      data.changed_matters = matter_list

  matter_collection.register_on_change_callback(callback)
  matter_collection.set_amount(Matter.URANIUM, 10)

  assert_true(data.called, "Callback should be called")
  assert_eq(data.changed_matters, [Matter.URANIUM])

  matter_collection.set_amount(Matter.NICKEL, 10)
  data.called = false
  data.changed_matters = [] 
  matter_collection.clear()

  assert_true(data.called, "Callback should be called")
  assert_eq(data.changed_matters, [Matter.URANIUM, Matter.NICKEL])
