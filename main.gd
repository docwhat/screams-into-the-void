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

  # Choose a random location on Path2D.
  var spawn_location : PathFollow2D = $AsteroidPath/AsteroidSpawnLocation
  spawn_location.progress = randi()

  # Set a random location.
  asteroid.position = spawn_location.position

  # Set path to the same direction.
  var direction : float = spawn_location.rotation + PI / 2

  # Add some randomness.
  direction += randf_range(-PI / 4, PI / 4)
  asteroid.rotation = direction

  # Choose a velocity.
  var velocity : Vector2 = Vector2(randf_range(150.0, 250.0), 0.0)
  asteroid.linear_velocity = velocity.rotated(direction)

  # Spawn it by adding to the Main scene
  add_child(asteroid)
