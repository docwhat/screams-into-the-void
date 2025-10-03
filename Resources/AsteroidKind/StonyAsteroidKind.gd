extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new({
	  Matter.Silicon: 40,
	  Matter.Magnesium: 10,
	})
