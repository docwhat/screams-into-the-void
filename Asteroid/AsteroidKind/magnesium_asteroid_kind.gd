extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new(
		{
			Matter.magnesium: 40,
		},
	)
