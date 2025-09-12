extends Control

func _unhandled_input(event: InputEvent) -> void:
  if event.is_action_pressed("pause"):
    unpause()
    get_viewport().set_input_as_handled()

func quit() -> void:
   get_tree().quit()

func unpause() -> void:
  Global.on_unpause_command.emit()
