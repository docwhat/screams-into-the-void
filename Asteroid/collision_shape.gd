extends CollisionPolygon2D

## If an event happens on the CollisionShape. e.g., a mouse click or a joystick click.
func _on_asteroid_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# This works better than _input() or _unhandled_input() because I don't have to do math to
	# figure out if the click is in the shape, which involves rotating things and adjusting
	# the mouse coordinates to be relative to 0,0 or adjusting the shape coordinames to global
	# coordinates.
	#
	# Requires input_pickable to be set to {true} and at least one collision_layer bit to be set.
	if event is not InputEventMouse:
		return

	var mouse_event: InputEventMouse = event as InputEventMouse

	if not mouse_event.is_pressed():
		return

	if not mouse_event.button_index == MOUSE_BUTTON_LEFT:
		return

	var highlight_color: Color = Color.LIME
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(%Outline, "default_color", Color(2, 2, 2), 0.1)
	tween.tween_property(%Outline, "default_color", highlight_color, 0.2)
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property(%Outline, "default_color", highlight_color.darkened(0.8), 1.2)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.parallel().tween_property(%Shape, "self_modulate", Color(2, 2, 1), 1.0)

	viewport.set_input_as_handled()
# Debugging which also shows an alternative way to check if the click is within the
# shape or not.
#print("NARF_on_asteroid_input_event: %s -- %s -- %s" % [
#"",
#self.to_local(mouse_event.position),
#Geometry2D.is_point_in_polygon(self.to_local(mouse_event.position), self.polygon),
#])

var tween: Tween
