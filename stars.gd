extends ColorRect

func _ready() -> void:
  # Save the default as the current value.
  Global.star_speed = self.material.get_shader_parameter("speed")
  

func _process(_delta: float) -> void:
  self.material.set_shader_parameter("speed", Global.star_speed)
