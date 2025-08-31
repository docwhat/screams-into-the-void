extends Control

func _ready() -> void:
  Global.rng.randomize()
  #resized.connect(_on_resized)
  var viewport : Viewport = get_viewport()

  # We're only using 2D here.
  viewport.set_disable_3d(true)

  print_rich("display: %dx%d  window: %dx%d  scale: %s" % [
    DisplayServer.screen_get_size().x,
    DisplayServer.screen_get_size().y,
    DisplayServer.window_get_size().x,
    DisplayServer.window_get_size().y,
    viewport.content_scale_size
  ])

func _on_asteroid_timer_timeout() -> void:
  var asteroid : RigidBody2D = preload("res://asteroid.tscn").instantiate()

  var screen_size = get_viewport_rect().size
  var spawn_margin = 100
  var target_position : Vector2 = Global.player_position
  var direction : float

  # Determine if this asteroid should intercept the player
  var should_intercept = Global.rng.randf() < Global.asteroid_player_intercept_chance

  # Determine spawn type based on bias
  var spawn_from_top = Global.rng.randf() < Global.asteroid_top_down_bias

  if spawn_from_top:
    # Spawn from top, moving downward
    asteroid.position.x = Global.rng.randf_range(-spawn_margin, screen_size.x + spawn_margin)
    asteroid.position.y = -spawn_margin

    if should_intercept:
      # Target the player
      target_position = $Player.global_position
      direction = asteroid.position.angle_to_point(target_position)
    else:
      # Move generally downward with some variation
      direction = Global.rng.randf_range(PI/4, 3*PI/4)
  else:
    # Spawn from other directions (left, right, or bottom)
    var side = Global.rng.randi_range(0, 3)
    match side:
      0: # Left side
        asteroid.position.x = -spawn_margin
        asteroid.position.y = Global.rng.randf_range(0, screen_size.y)
        if should_intercept:
          target_position = $Player.global_position
          direction = asteroid.position.angle_to_point(target_position)
        else:
          direction = Global.rng.randf_range(-PI/4, PI/4)  # Generally rightward
      1: # Right side
        asteroid.position.x = screen_size.x + spawn_margin
        asteroid.position.y = Global.rng.randf_range(0, screen_size.y)
        if should_intercept:
          target_position = $Player.global_position
          direction = asteroid.position.angle_to_point(target_position)
        else:
          direction = Global.rng.randf_range(3*PI/4, 5*PI/4)  # Generally leftward
      2: # Bottom
        asteroid.position.x = Global.rng.randf_range(0, screen_size.x)
        asteroid.position.y = screen_size.y + spawn_margin
        if should_intercept:
          target_position = $Player.global_position
          direction = asteroid.position.angle_to_point(target_position)
        else:
          direction = Global.rng.randf_range(-3*PI/4, -PI/4)  # Generally upward

  asteroid.rotation = direction

  # Choose a velocity
  var speed = Global.rng.randf_range(150.0, 250.0)
  var velocity = Vector2(speed, 0.0).rotated(direction)
  asteroid.linear_velocity = velocity

  # Spawn it by adding to the Main scene
  add_child(asteroid)
