extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new({
	  Matter.Water: 70,
	  Matter.Copper: 2,
	  Matter.Helium: 2,
	  Matter.Nitrogen: 2,
	  Matter.Nickel: 2,
	})
