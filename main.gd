extends Control

func _ready() -> void:
	Global.rng.randomize()
	#resized.connect(_on_resized)
	var viewport : Viewport = get_viewport()

	# We're only using 2D here.
	viewport.set_disable_3d(true)

	# Connect Signals
	Events.unpause.connect(unpause)
	Events.pause.connect(pause)

	pause()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()

func pause() -> void:
	get_tree().set_pause(true)
	%PauseMenu.show()

func unpause() -> void:
	get_tree().set_pause(false)
	%PauseMenu.hide()

func toggle_pause() -> void:
	if get_tree().is_paused():
		Events.emit_unpause()
	else:
		Events.emit_pause()


func _on_asteroid_timer_timeout() -> void:
	var scene = preload("res://Asteroid/Asteroid.tscn")
	var screen_size : Vector2 = get_viewport_rect().size

	# Check if an asteroid should spawn.
	var count : int = Global.number_of_asteroids_to_spawn()

	for i: int in range(count):
		# Sleep if this asteroid isn't the only one being spawned in a row.
		if i > 0:
			await get_tree().create_timer(0.15).timeout

		var asteroid = scene.instantiate()
		asteroid.launch(screen_size, $Player.global_position)

		if asteroid.is_valid():
			add_child(asteroid)


# EOF
