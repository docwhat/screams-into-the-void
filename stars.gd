extends ColorRect

var time: float = 0.0:
	set(value):
		time = value
		self.material.set_shader_parameter("time", time)


func _ready() -> void:
	time = Global.rng.randf_range(1.0, 40_000.0)


func _process(delta: float) -> void:
	time += delta * Global.star_speed
