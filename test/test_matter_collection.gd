extends GutTest

# Test file for MatterCollection class
class_name TestMatterCollection

var matter_collection: MatterCollection
var other_collection: MatterCollection

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
  for matter_type in Global.Matter.values():
    assert_eq(matter_collection.get_amount(matter_type), 0,
      "Matter type %s should be initialized to 0.0" % [matter_type])

func test_clear_resets_all_matter_to_zero():
  # Set some values first
  matter_collection.set_amount(Global.Matter.CARBON, 10)
  matter_collection.set_amount(Global.Matter.WATER, 5)

  # Clear and verify all are zero
  matter_collection.clear()

  for matter_type in Global.Matter.values():
    assert_eq(matter_collection.get_amount(matter_type), 0,
      "Matter type %s should be cleared to 0" % [matter_type])

# Test get_amount functionality
func test_get_amount_returns_correct_value():
  matter_collection.collection[Global.Matter.CARBON] = 15
  assert_eq(matter_collection.get_amount(Global.Matter.CARBON), 15,
    "get_amount should return the exact value stored")

func test_get_amount_different_matter_types():
  matter_collection.collection[Global.Matter.WATER] = 7
  matter_collection.collection[Global.Matter.IRON] = 12

  assert_eq(matter_collection.get_amount(Global.Matter.WATER), 7)
  assert_eq(matter_collection.get_amount(Global.Matter.IRON), 12)
  assert_eq(matter_collection.get_amount(Global.Matter.CARBON), 0)

# Test set_amount functionality
func test_set_amount_positive_value():
  matter_collection.set_amount(Global.Matter.SILICON, 25)
  assert_eq(matter_collection.get_amount(Global.Matter.SILICON), 25,
    "set_amount should set the exact positive value")

func test_set_amount_zero_value():
  matter_collection.set_amount(Global.Matter.COPPER, 0)
  assert_eq(matter_collection.get_amount(Global.Matter.COPPER), 0,
    "set_amount should handle zero values")

func test_set_amount_negative_numbers_are_not_allowed():
  matter_collection.set_amount(Global.Matter.URANIUM, -15)
  assert_eq(matter_collection.get_amount(Global.Matter.URANIUM), 15,
    "set_amount should convert negative values to positive using abs()")

func test_set_amount_overwrites_existing():
  matter_collection.set_amount(Global.Matter.CARBON, 10)
  matter_collection.set_amount(Global.Matter.CARBON, 20)
  assert_eq(matter_collection.get_amount(Global.Matter.CARBON), 20,
    "set_amount should overwrite existing values")

# Test add_amount functionality
func test_add_amount_to_zero():
  matter_collection.add_amount(Global.Matter.WATER, 5)
  assert_eq(matter_collection.get_amount(Global.Matter.WATER), 5,
    "add_amount should add to zero base value")

func test_add_amount_to_existing():
  matter_collection.set_amount(Global.Matter.IRON, 10)
  matter_collection.add_amount(Global.Matter.IRON, 7)
  assert_eq(matter_collection.get_amount(Global.Matter.IRON), 17,
    "add_amount should add to existing value")

func test_add_amount_with_negative():
  matter_collection.set_amount(Global.Matter.SILICON, 20)
  matter_collection.add_amount(Global.Matter.SILICON, -5)
  assert_eq(matter_collection.get_amount(Global.Matter.SILICON), 15,
    "add_amount should handle negative additions")

func test_add_amount_will_zero_on_underflow():
  matter_collection.set_amount(Global.Matter.COPPER, 3)
  matter_collection.add_amount(Global.Matter.COPPER, -5)
  assert_eq(matter_collection.get_amount(Global.Matter.COPPER), 0,
    "add_amount should not allow negative results, clamping to 0")

func test_add_amount_add_nothing():
  matter_collection.set_amount(Global.Matter.URANIUM, 8)
  matter_collection.add_amount(Global.Matter.URANIUM, 0)
  assert_eq(matter_collection.get_amount(Global.Matter.URANIUM), 8,
    "add_amount with zero should not change the value")

# Test remove_amount functionality
func test_remove_amount_from_existing():
  matter_collection.set_amount(Global.Matter.CARBON, 15)
  matter_collection.remove_amount(Global.Matter.CARBON, 5)
  assert_eq(matter_collection.get_amount(Global.Matter.CARBON), 10,
    "remove_amount should subtract from existing value")

func test_remove_amount_exact_amount():
  matter_collection.set_amount(Global.Matter.WATER, 7)
  matter_collection.remove_amount(Global.Matter.WATER, 7)
  assert_eq(matter_collection.get_amount(Global.Matter.WATER), 0,
    "remove_amount should handle removing exact amount")

func test_remove_amount_more_than_available():
  matter_collection.set_amount(Global.Matter.SILICON, 3)
  matter_collection.remove_amount(Global.Matter.SILICON, 10)
  assert_eq(matter_collection.get_amount(Global.Matter.SILICON), 0,
    "remove_amount should not allow negative results, clamping to 0")

func test_remove_amount_from_zero():
  matter_collection.remove_amount(Global.Matter.IRON, 5)
  assert_eq(matter_collection.get_amount(Global.Matter.IRON), 0,
    "remove_amount from zero should remain zero")

func test_remove_amount_negative_value():
  matter_collection.set_amount(Global.Matter.COPPER, 10)
  matter_collection.remove_amount(Global.Matter.COPPER, -3)
  assert_eq(matter_collection.get_amount(Global.Matter.COPPER), 13,
    "remove_amount with negative value should add to the amount")

# Test add_collection functionality
func test_add_collection_empty_to_empty():
  matter_collection.add_collection(other_collection)

  for matter_type in Global.Matter.values():
    assert_eq(matter_collection.get_amount(matter_type), 0,
      "Adding empty collection to empty should remain zero")

func test_add_collection_empty_to_non_empty():
  matter_collection.set_amount(Global.Matter.SILICON, 5)
  other_collection.set_amount(Global.Matter.SILICON, 3)
  matter_collection.add_collection(other_collection)
  assert_eq(matter_collection.get_amount(Global.Matter.SILICON), 8,
    "Adding empty collection to non-empty should add the amounts")

func test_add_collection_non_empty_to_empty():
  matter_collection.set_amount(Global.Matter.SILICON, 5)
  other_collection.set_amount(Global.Matter.SILICON, 3)
  matter_collection.add_collection(other_collection)
  assert_eq(matter_collection.get_amount(Global.Matter.SILICON), 8,
    "Adding non-empty collection to empty should add the amounts")

func test_add_collection_non_empty_to_non_empty():
  matter_collection.set_amount(Global.Matter.SILICON, 5)
  other_collection.set_amount(Global.Matter.SILICON, 3)
  matter_collection.add_collection(other_collection)
  assert_eq(matter_collection.get_amount(Global.Matter.SILICON), 8,
    "Adding non-empty collection to non-empty should add the amounts")

# Test fill functionality
func test_fill_works():
  matter_collection.fill(23)
  for matter in Global.Matter.values():
    assert_eq(matter_collection.get_amount(matter), 23,
      "fill() should set all amounts to the given value")

func test_fill_negative_value():
  matter_collection.fill(-5)
  for matter in Global.Matter.values():
    assert_eq(matter_collection.get_amount(matter), 0)
