extends Control

var asteroid_launcher: AsteroidLauncher


func _init_global() -> void:
	Global.rng.randomize()
	Global.play_field = %PlayField
	Global.player_node = %Player
	Global.viewport = get_viewport()


func _ready() -> void:
	_init_global()

	# We're only using 2D here.
	Global.viewport.set_disable_3d(true)

	# Connect Signals
	Events.unpause.connect(unpause)
	Events.pause.connect(pause)

	# Start unpaused if running in the editor.
	if Engine.is_embedded_in_editor() or OS.has_feature("editor"):
		unpause()
	else:
		# Start paused if running as a game.
		pause()

	await get_tree().process_frame
	asteroid_launcher = AsteroidLauncher.new()
	add_child(asteroid_launcher)
	asteroid_launcher.start()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause") and not get_tree().is_paused():
		pause()
		get_viewport().set_input_as_handled()


## Pause the game and show the pause menu.
func pause() -> void:
	get_tree().set_pause(true)
	%PauseMenu.show()


## Unpause the game and hide the pause menu.
func unpause() -> void:
	get_tree().set_pause(false)
	%PauseMenu.hide()

# EOF
