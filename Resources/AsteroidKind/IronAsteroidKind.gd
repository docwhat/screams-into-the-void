extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new({
	  Matter.Iron: 50,
	  Matter.Nickel: 20,
	})
