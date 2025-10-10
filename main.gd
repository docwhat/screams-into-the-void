extends Control

func _ready() -> void:
	Global.rng.randomize()
	#resized.connect(_on_resized)
	var viewport: Viewport = get_viewport()

	# We're only using 2D here.
	viewport.set_disable_3d(true)

	# Connect Signals
	Events.unpause.connect(unpause)
	Events.pause.connect(pause)

	# Start unpaused if running in the editor.
	if Engine.is_embedded_in_editor() or OS.has_feature("editor"):
		unpause()
	else:
		# Start paused if running as a game.
		pause()


## Spawn asteroids periodically.
# TODO: Move to separate AsteroidLauncher or AsteroidSpawner node.
func _on_asteroid_timer_timeout() -> void:
	var scene = preload("res://Asteroid/asteroid.tscn")
	var screen_size: Vector2 = get_viewport_rect().size

	# Check if an asteroid should spawn.
	var count: int = Global.number_of_asteroids_to_spawn()

	for i: int in range(count):
		# Sleep if this asteroid isn't the only one being spawned in a row.
		if i > 0:
			await get_tree().create_timer(0.15).timeout

		var asteroid = scene.instantiate()
		add_child(asteroid, true)

		# Launch the asteroid next frame so that it's fully initialized (ready).
		asteroid.launch.call_deferred(screen_size, $Player.global_position)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()


## Pause the game and show the pause menu.
func pause() -> void:
	get_tree().set_pause(true)
	%PauseMenu.show()


## Unpause the game and hide the pause menu.
func unpause() -> void:
	get_tree().set_pause(false)
	%PauseMenu.hide()


## Toggle the pause state.
func toggle_pause() -> void:
	if get_tree().is_paused():
		Events.emit_unpause()
	else:
		Events.emit_pause()

# EOF
