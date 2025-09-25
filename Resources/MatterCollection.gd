class_name MatterCollection extends Resource

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
    MAGNESIUM = 7,
    HYDROGEN = 8,
    OXYGEN = 9,
}

static func mass(matter : Matter) -> float:
  match matter:
    Matter.CARBON: return 12.0096
    Matter.WATER: return mass(Matter.HYDROGEN) * 2.0 + mass(Matter.OXYGEN)
    Matter.SILICON: return 28.084
    Matter.IRON: return 55.845
    Matter.COPPER: return 12.0096
    Matter.URANIUM: return 238.02891
    Matter.NICKEL: return 58.6934
    Matter.HYDROGEN: return 1.00784
    Matter.OXYGEN: return 15.999
    Matter.MAGNESIUM: return 54.938043

  assert(false, "Unknown matter %s" % str(matter))
  return 1.0

# Reverse Lookup
static var AntiMatter : Dictionary[Matter, String]

static func _static_init() -> void:
  # Build the anti-matter dictionary.
  for k : String in Matter.keys():
    var v : Matter = Matter[k]
    AntiMatter[v] = k

@export var carbon : int:
  set(value):
    set_amount(Matter.CARBON, value)
  get:
    return get_amount(Matter.CARBON)

@export var water : int:
  set(value):
    set_amount(Matter.WATER, value)
  get:
    return get_amount(Matter.WATER)

@export var silicon : int:
  set(value):
    set_amount(Matter.SILICON, value)
  get:
    return get_amount(Matter.SILICON)

@export var iron : int:
  set(value):
    set_amount(Matter.IRON, value)
  get:
    return get_amount(Matter.IRON)

@export var copper : int:
  set(value):
    set_amount(Matter.COPPER, value)
  get:
    return get_amount(Matter.COPPER)

@export var uranium : int:
  set(value):
    set_amount(Matter.URANIUM, value)
  get:
    return get_amount(Matter.URANIUM)

@export var nickel : int:
  set(value):
    set_amount(Matter.NICKEL, value)
  get:
    return get_amount(Matter.NICKEL)

@export var magnesium : int:
  set(value):
    set_amount(Matter.MAGNESIUM, value)
  get:
    return get_amount(Matter.MAGNESIUM)

# A float array to store the amount of each matter in the _collection.
var _collection : Array[int]

# A list of functions to call when the collection changes.
var _on_change_callbacks : Array[Callable]

func _init() -> void:
  _collection = []
  _collection.resize(Matter.values().size())

func matter_mass() -> float:
  var total_mass : float = 0.0
  for m : Matter in Matter.values():
    total_mass += float(get_amount(m)) * mass(m)
  return total_mass

func fill(value : int) -> void:
  var changed_matter : Array[Matter] = []
  for m : Matter in Matter.values():
    if get_amount(m) != value:
      changed_matter.append(m)
      _collection[m] = max(0, value)
  _changed(changed_matter)

# Get via Matter enum.
func get_amount(matter : Matter) -> int:
  return _collection[matter]

# Set via Matter enum.
func set_amount(matter : Matter, value : int) -> void:
  _collection[matter] = max(0, value)
  _changed([matter])

# Alias for fill(0)
func clear() -> void:
  fill(0)

# Functions to call when any value changes.
func _changed(changed_matters: Array[Matter]) -> void:
  for fn in _on_change_callbacks:
    fn.call(changed_matters)

# Add a function to call when any value changes.
func register_on_change_callback(fn: Callable) -> void:
  _on_change_callbacks.append(fn)

# String get/set
func get_by_string(matter : String) -> int:
  return get_amount(Matter[matter.to_upper()])

func set_by_string(matter : String, value : int) -> void:
  set_amount(Matter[matter.to_upper()], abs(value))

# Increments a matter by amount.
func incr_amount(matter : Matter, amount : int) -> void:
  set_amount(matter, max(0, get_amount(matter) + amount))

# Decrements a matter by amount.
func decr_amount(matter : Matter, amount : int) -> void:
  set_amount(matter, max(0, get_amount(matter) - amount))

# Perform an operation on every matter in the collection.
# lambda should accept matter and amount.
func each(lambda : Callable) -> void:
  for matter : Matter in Matter.values():
    lambda.call(matter, get_amount(matter))

# Adds this collection to another collection.
func add_collection(other : MatterCollection) -> void:
  var changed_matter : Array[Matter] = []
  for m : Matter in Matter.values():
    var amt : int = other.get_amount(m)
    if amt > 0:
      #_collection[m] = max(0, _collection[m] + amt)
      incr_amount(m, amt)
      changed_matter.append(m)
  _changed(changed_matter)

# EOF
