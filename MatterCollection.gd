class_name MatterCollection

# A float array to store the amount of each matter in the collection.
var collection : Array[int]

func _init() -> void:
  collection = []
  collection.resize(Global.Matter.values().size())
  clear()

func clear() -> void:
  fill(0)

func fill(value : int) -> void:
  collection.fill(max(0, value))

func get_amount(matter : Global.Matter) -> int:
  return collection[matter]

func set_amount(matter : Global.Matter, value : int) -> void:
  collection[matter] = abs(value)

func get_by_string(matter : String) -> int:
  return get_amount(Global.Matter[matter.to_upper()])

func set_by_string(matter : String, value : int) -> void:
  set_amount(Global.Matter[matter.to_upper()], abs(value))

func add_amount(matter : Global.Matter, value : int) -> void:
  collection[matter] = max(0, collection[matter] + value)

func remove_amount(matter : Global.Matter, value : int) -> void:
  collection[matter] = max(0, collection[matter] - value)

func add_collection(other : MatterCollection) -> void:
  for matter_idx in Global.Matter.values():
    add_amount(matter_idx, other.get_amount(matter_idx))

func remove_collection(other : MatterCollection) -> void:
  for matter_idx in Global.Matter.values():
    remove_amount(matter_idx, other.get_amount(matter_idx))
