extends AsteroidKind

func _init() -> void:
	matter = MatterBag.new(
		{
			Matter.iron: 50,
			Matter.nickel: 20,
		},
	)
