extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new(
		{
			Matter.silicon: 40,
			Matter.magnesium: 10,
		},
	)
