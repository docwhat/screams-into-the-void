extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new(
		{
			Matter.uranium: 20,
		},
	)
