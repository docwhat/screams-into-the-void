extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new(
		{
			Matter.water: 70,
			Matter.copper: 2,
			Matter.helium: 2,
			Matter.nitrogen: 2,
			Matter.nickel: 2,
		},
	)
