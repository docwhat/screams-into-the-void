extends Node2D

## Returns a randomly modulated number that is possible negative.
func rand_torque(t: float) -> float:
	var variation: float = t * 0.20
	var base: float = t - variation
	var torque: float = base + Global.rng.randf_range(0, variation * 2.0)
	if Global.flip_coin() == 0:
		torque = 0 - torque
	return torque


func _ready() -> void:
	# Find all the Asteroids under the Node2D grouping nodes and start them spinning.
	for asteroid: Asteroid in get_tree().get_nodes_in_group(&"asteroid"):
		asteroid.apply_torque_impulse(rand_torque(asteroid.inertia * 0.8))
		asteroid.freeze = false

# EOF
