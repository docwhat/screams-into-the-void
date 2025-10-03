extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new({
	  Matter.Silicon: 10,
	  Matter.Carbon: 20,
	  Matter.Water: 20,
	  Matter.Nitrogen: 10,
	  Matter.Helium: 1,
	  Matter.Silicon: 10,
	})
