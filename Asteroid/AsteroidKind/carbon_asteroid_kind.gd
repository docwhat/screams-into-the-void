extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new(
		{
			Matter.carbon: 70,
		},
	)
