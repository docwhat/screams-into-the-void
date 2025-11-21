class_name AsteroidLauncher
extends Node2D

## The asteroid scene to spawn.
const ASTEROID: PackedScene = preload("uid://dgo8gq5d22uf")


func start() -> void:
	while true:
		# Calculate the next spawn timer value based on the number of asteroids.
		var next_spawn_time: float = calculate_spawn_timer()

		# Wait for the calculated time.
		await get_tree().create_timer(next_spawn_time, false).timeout

		# Only spawn if there is still room on the screen.
		if Global.asteroid_count < Global.asteroid_max:
			spawn_asteroids()


func calculate_spawn_timer() -> float:
	# Normalize the current asteroid count (between 0 and 1).
	var normalized_count: float = float(Global.asteroid_count) / Global.asteroid_max

	# Calculate the exponential decay timer value.
	# The `pow()` function is equivalent to the exponentiation operator in GDScript.
	var timer_decay: float = pow(1.0 - normalized_count, 2.0)

	# Map the decay value to the timer range [min_spawn_timer, max_spawn_timer].
	var calculated_timer: float = lerp(
		Global.asteroid_min_spawn_timer,
		Global.asteroid_max_spawn_timer,
		timer_decay,
	)

	# Add random adjustment to the calculated timer.
	var random_factor: float = 1.0 + randf_range(
		-Global.asteroid_spawn_randomness,
		Global.asteroid_spawn_randomness,
	)
	var final_timer: float = calculated_timer * random_factor

	# Ensure the final timer is within the defined bounds.
	return clamp(
		final_timer,
		Global.asteroid_min_spawn_timer,
		Global.asteroid_max_spawn_timer,
	)


func spawn_asteroids() -> void:
	# Determine how many asteroids to spawn.
	var num_to_spawn: int = randi_range(
		Global.asteroid_min_asteroids_to_add,
		Global.asteroid_max_asteroids_to_add,
	)

	for i: int in range(num_to_spawn):
		spawn_one_asteroid()


func spawn_one_asteroid() -> void:
	if Global.asteroid_count >= Global.asteroid_max:
		return

	var new_asteroid: Asteroid = ASTEROID.instantiate()
	Global.play_field.add_child(new_asteroid, true)
	new_asteroid.launch.call_deferred()
