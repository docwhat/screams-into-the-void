extends ColorRect

var last_star_speed: float = 0.0
var time: float = 0.0


func _ready() -> void:
	time = Global.rng.randf_range(1.0, 40_000.0)
	_update_shader()


func _process(delta: float) -> void:
	time += delta
	_update_shader()


func _update_shader() -> void:
	self.material.set_shader_parameter("time", time)
	if last_star_speed != Global.star_speed:
		self.material.set_shader_parameter("speed", Global.star_speed)
		last_star_speed = Global.star_speed
