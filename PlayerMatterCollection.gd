class_name PlayerMatterCollection extends MatterCollection

# A version of MatterCollection that updates the hud on changes.

func fill(value : int) -> void:
  super.fill(value)
  Events.emit_update_hud()
  
func set_amount(matter : Matter, value : int) -> void:
  super.set_amount(matter, value)
  Events.emit_update_hud()
