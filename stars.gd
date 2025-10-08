extends ColorRect

## The math in the shader goes wonky around here.
##
## This was determined by experimentation, not by
## mathematics, so I don't know why (yet).
##
## This is about (7500 * 100) / (60 * 60 * 24) = 8.7 days.
const MAX_TIME: float = 7_500

var time: float = 0.0:
	set(value):
		time = value
		self.material.set_shader_parameter("time", time)


func _ready() -> void:
	time = Global.rng.randf_range(0, MAX_TIME / 1_000)


var last_a: int = 0


func _process(delta: float) -> void:
	# TODO: figure out how to remove the hiccup when it wraps from MAX_TIME
	# to 0.0.
	time = fposmod(time + delta * Global.star_speed, MAX_TIME)
