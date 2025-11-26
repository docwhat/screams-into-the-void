extends Node2D

## Returns a randomly modulated number that is possibly negative.
func rand_angular_velocity(t: float) -> float:
	var variation: float = t * 0.20
	var base: float = t - variation
	var angular_velocity: float = base + Global.rng.randf_range(
		0 - TAU / 4.0,
		TAU / 4.0,
	) * variation
	if Global.flip_coin() == 0:
		angular_velocity = 0 - angular_velocity
	return angular_velocity


func _ready() -> void:
	# Find all the Asteroids under the Node2D grouping nodes and start them spinning.
	for asteroid: Asteroid in get_tree().get_nodes_in_group(&"asteroid"):
		var new_av: float = rand_angular_velocity(0.80 + 0.2 * asteroid.inertia)
		asteroid.angular_velocity = new_av


func _rebuild() -> void:
	for asteroid: Asteroid in get_tree().get_nodes_in_group(&"asteroid"):
		asteroid.rebuild()
