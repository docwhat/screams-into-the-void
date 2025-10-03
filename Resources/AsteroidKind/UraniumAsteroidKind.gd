extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new({
	  Matter.Uranium: 20,
	})
