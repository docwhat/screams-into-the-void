extends Control

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("pause"):
    unpause()
    get_viewport().set_input_as_handled()

func quit() -> void:
   Global.quit()

func unpause() -> void:
  Events.emit_unpause()

func _on_visibility_changed() -> void:
  if visible:
    %Play.grab_focus.call_deferred()
