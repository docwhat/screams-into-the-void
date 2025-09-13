extends Control

enum Side {
  TOP,
  LEFT,
  RIGHT,
  BOTTOM
}

func _ready() -> void:
  Global.rng.randomize()
  #resized.connect(_on_resized)
  var viewport : Viewport = get_viewport()

  # We're only using 2D here.
  viewport.set_disable_3d(true)

  # Connect Signals
  Global.on_unpause_command.connect(unpause)

  # Pause everything.
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
    unpause()
  else:
    pause()

# Asteroids start off screen. We need to ensure they spawn far enough off screen
# that they can't be seen.
func calculate_asteroid_starting_position() -> Vector2:
  var screen_size : Vector2 = get_viewport_rect().size

  # Distance from edge of screen to the asteroid off screen.
  var spawn_margin : int = 100

  # Where the asteroid should spawn.
  var sides = [Side.TOP, Side.LEFT, Side.RIGHT, Side.BOTTOM]
  var side_weights : PackedFloat32Array = [5, 1.5, 1.5, 0.1]

  var side_index = Global.rng.rand_weighted(side_weights)
  match sides[side_index]:
    Side.LEFT:
      return Vector2(
        -spawn_margin,
        Global.rng.randf_range(0, screen_size.y)
      )
    Side.RIGHT:
      return Vector2(
        screen_size.x + spawn_margin,
        Global.rng.randf_range(0, screen_size.y)
      )
    Side.BOTTOM:
      return Vector2(
        Global.rng.randf_range(0, screen_size.x),
        screen_size.y + spawn_margin
      )
    _: # AKA Side.TOP
      return Vector2(
        Global.rng.randf_range(-spawn_margin, screen_size.x + spawn_margin),
        -spawn_margin
      )



func _on_asteroid_timer_timeout() -> void:
  var asteroid : RigidBody2D = preload("res://asteroid.tscn").instantiate()
  var screen_size : Vector2 = get_viewport_rect().size

  var target_coord : Vector2
  var direction : float

  # Determine if this asteroid should intercept the player
  var should_intercept = Global.rng.randf() < Global.asteroid_player_intercept_chance

  # Need to freeze the asteroid prior to making changes.
  asteroid.set_freeze_enabled(true)
  asteroid.position = calculate_asteroid_starting_position()

  if should_intercept:
    target_coord = $Player.global_position
  else:
    target_coord = Vector2(
      Global.rng.randf_range(0, screen_size.x),
      Global.rng.randf_range(0, screen_size.y)
    )
  direction = asteroid.position.angle_to_point(target_coord)

  # Choose a velocity
  var speed = Global.rng.randf_range(100.0, 150.0)
  var velocity = Vector2(speed, 0.0).rotated(direction)

  # Restore the physics.
  asteroid.set_freeze_enabled(false)

  # Send it on its way.
  asteroid.apply_impulse(velocity)

  # Spawn it by adding to the Main scene
  add_child(asteroid)
