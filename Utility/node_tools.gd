class_name NodeTools
extends RefCounted

## Draw an arrow from origin to target.
##
## [node] is the Node2D to draw on.
## [origin] is the starting point of the arrow.
## [target] is the ending point of the arrow.
## [color] is the color of the arrow.
## [width] is the width of the arrow line. If -1, uses default width.
## [filled] if true, draws a filled arrowhead; otherwise, draws an outline.
## [head_length] is the length of the arrowhead.
## [head_angle] is the angle of the arrowhead (in radians).
static func draw_arrow(
		node: Node2D,
		origin: Vector2,
		target: Vector2,
		color: Color,
		width: float = -1,
		filled: bool = false,
		head_length: float = 2.5,
		head_angle: float = TAU / 2.0,
) -> void:
	target -= origin * 2
	var head: Vector2 = -target.normalized() * head_length
	var end = -target.normalized() * head_length / 2 + target + origin
	target += origin
	var head_right = target + head.rotated(head_angle)
	var head_left = target + head.rotated(-head_angle)

	if filled:
		node.draw_line(origin, end, color, width)
		node.draw_colored_polygon([head_right, target, head_left], color)
	else:
		node.draw_line(origin, target, color, width)
		node.draw_polyline([head_right, target, head_left], color, width)
