class_name Player extends StaticBody2D

func _ready() -> void:
  get_viewport().connect("size_changed", _on_resized)
  recenter_player.call_deferred()

func recenter_player():
  var screen_size = get_viewport_rect().size
  var new_position = Vector2(
    screen_size.x / 2.0,
    screen_size.y - Global.player_size.y / 1.5
  )

  position = new_position
  Global.player_position = new_position

func _on_resized():
  recenter_player.call_deferred()
