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

	await get_tree().process_frame
	asteroid_launcher = AsteroidLauncher.new()
	add_child(asteroid_launcher)
	asteroid_launcher.start()

	# Start unpaused if running in the editor.
	if Engine.is_embedded_in_editor() or OS.has_feature("editor"):
		$CurrentWindow.play_field()
	else:
		$CurrentWindow.pause()

# EOF
