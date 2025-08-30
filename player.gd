class_name Player extends Area2D

func recenter_player():
  var screen_size = get_viewport_rect().size

  $AnimatedSprite2D.position.x = screen_size.x / 2.0
  $AnimatedSprite2D.position.y = screen_size.y - Global.player_size.y / 1.5

func _ready() -> void:
  # Values must be initialized before running anything else.
  recenter_player()

func _process(_delta: float) -> void:
  recenter_player()
