extends Control

#@onready var stars = $Stars
#@onready var arc: AspectRatioContainer = $Stars/AspectRatioContainer

@onready var planets = {
  # "Terran Wet": preload("res://Planets/Rivers/Rivers.tscn"),
  # "Terran Dry": preload("res://Planets/DryTerran/DryTerran.tscn"),
  # "Islands": preload("res://Planets/LandMasses/LandMasses.tscn"),
  # "No atmosphere": preload("res://Planets/NoAtmosphere/NoAtmosphere.tscn"),
  # "Gas giant 1": preload("res://Planets/GasPlanet/GasPlanet.tscn"),
  # "Gas giant 2": preload("res://Planets/GasPlanetLayers/GasPlanetLayers.tscn"),
  # "Ice World": preload("res://Planets/IceWorld/IceWorld.tscn"),
  # "Lava World": preload("res://Planets/LavaWorld/LavaWorld.tscn"),
  "Asteroid": preload("res://Planets/Asteroids/Asteroid.tscn"),
  # "Black Hole": preload("res://Planets/BlackHole/BlackHole.tscn"),
  # "Galaxy": preload("res://Planets/Galaxy/Galaxy.tscn"),
  # "Star": preload("res://Planets/Star/Star.tscn"),
}

func _ready() -> void:
  Global.rng.randomize()
  #resized.connect(_on_resized)
  var viewport : Viewport = get_viewport()

  # We're only using 2D here.
  viewport.set_disable_3d(true)
  #viewport.content_scale_size = Global.resolution
  #update_container.call_deferred()

  print_rich("display: %dx%d  window: %dx%d  scale: %s" % [
    DisplayServer.screen_get_size().x,
    DisplayServer.screen_get_size().y,
    DisplayServer.window_get_size().x,
    DisplayServer.window_get_size().y,
    viewport.content_scale_size
  ])

  #$Stars.size = viewport.content_scale_size
  #print_rich("stars: %s" % $Background.$Stars.size)

#func _on_resized() -> void:
  #update_container.call_deferred()
  #
#func update_container() -> void:
  ## The code within this function needs to be run deferred to work around an issue with containers
  ## having a 1-frame delay with updates.
  ## Otherwise, `panel.size` returns a value of the previous frame, which results in incorrect
  ## sizing of the inner AspectRatioContainer when using the Fit to Window setting.
  #for _i in 2:
      ## Fit to Window. Tell the AspectRatioContainer to use the same aspect ratio as the window,
      ## making the AspectRatioContainer not have any visible effect.
      #arc.ratio = stars.size.aspect()


func _on_asteroid_timer_timeout() -> void:
  var base_node = planets["Asteroid"]
  var asteroid = base_node.instantiate()

  #asteroid.seed(Global.rng.randi())
  asteroid.set_pixels(64)

  var screen_size = get_viewport_rect().size
  var spawn_margin = 100
  var direction : float
  var target_position : Vector2
  
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
    var side = Global.rng.randi() % 3
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
