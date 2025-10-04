extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new(
		{
			Matter.silicon: 10,
			Matter.carbon: 20,
			Matter.water: 20,
			Matter.nitrogen: 10,
			Matter.helium: 1,
			Matter.silicon: 10,
		},
	)
