extends ColorRect

var last_star_speed: float = 0.0


func _process(_delta: float) -> void:
	if last_star_speed != Global.star_speed:
		self.material.set_shader_parameter("speed", Global.star_speed)
		last_star_speed = Global.star_speed
