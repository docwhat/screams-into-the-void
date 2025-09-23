class_name MatterCollection

# Materials. Never delete any. Never change any numbers. Otherwise
# saves won't work.
enum Matter {
    CARBON = 0,
    WATER = 1,
    SILICON = 2,
    IRON = 3,
    COPPER = 4,
    URANIUM = 5,
    NICKEL = 6,
    MAGNESIUM = 7
}

static var AntiMatter : Dictionary[Matter, String]

static func _static_init() -> void:
  for k : String in Matter.keys():
    var v : Matter = Matter[k]
    AntiMatter[v] = k

var carbon : int:
  set(value):
    collection[Matter.CARBON] = max(0, abs(value))
  get:
    return collection[Matter.CARBON]

var water : int:
  set(value):
    collection[Matter.WATER] = max(0, abs(value))
  get:
    return collection[Matter.WATER]

var silicon : int:
  set(value):
    collection[Matter.SILICON] = max(0, abs(value))
  get:
    return collection[Matter.SILICON]

var iron : int:
  set(value):
    collection[Matter.IRON] = max(0, abs(value))
  get:
    return collection[Matter.IRON]

var copper : int:
  set(value):
    collection[Matter.COPPER] = max(0, abs(value))
  get:
    return collection[Matter.COPPER]

var uranium : int:
  set(value):
    collection[Matter.URANIUM] = max(0, abs(value))
  get:
    return collection[Matter.URANIUM]

var nickel : int:
  set(value):
    collection[Matter.NICKEL] = max(0, abs(value))
  get:
    return collection[Matter.NICKEL]

var magnesium : int:
  set(value):
    collection[Matter.MAGNESIUM] = max(0, abs(value))
  get:
    return collection[Matter.MAGNESIUM]

# A float array to store the amount of each matter in the collection.
var collection : Array[int]

func _init() -> void:
  collection = []
  collection.resize(Matter.values().size())
  clear()

func clear() -> void:
  fill(0)

func fill(value : int) -> void:
  collection.fill(max(0, value))

# Enum get/set
func get_amount(matter : Matter) -> int:
  return collection[matter]

func set_amount(matter : Matter, value : int) -> void:
  collection[matter] = abs(value)

# String get/set
func get_by_string(matter : String) -> int:
  return get_amount(Matter[matter.to_upper()])

func set_by_string(matter : String, value : int) -> void:
  set_amount(Matter[matter.to_upper()], abs(value))

# Increments a matter by amount.
func incr_amount(matter : Matter, amount : int) -> void:
  set_amount(matter, max(0, collection[matter] + amount))

# Decrements a matter by amount.
func decr_amount(matter : Matter, amount : int) -> void:
  set_amount(matter, max(0, collection[matter] - amount))

# Perform an operation on every matter in the collection.
# lambda should accept matter and amount.
func each(lambda : Callable) -> void:
  for matter : Matter in Matter.values():
    lambda.call(matter, get_amount(matter))

# Adds this collection to another collection.
func add_collection(other : MatterCollection) -> void:
  for matter_idx in Matter.values():
    incr_amount(matter_idx, other.get_amount(matter_idx))

# Subtracts another collection from this collection.
func remove_collection(other : MatterCollection) -> void:
  for matter_idx in Matter.values():
    decr_amount(matter_idx, other.get_amount(matter_idx))

# EOF
