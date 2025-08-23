extends Node

func _onready() -> void:
  if not Global.rng.is_seeded():
    Global.rng.randomize()
