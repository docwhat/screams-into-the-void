class_name Reactive extends Resource

var repr : String
static var count : int = 0

var parent: Reactive:
	set(new_parent):
		# Disconnect old parent.
		if parent != null:
			reactive_changed.disconnect(parent._propagate)

		# Set the parent.
		parent = new_parent

		# Connect new parent.
		if parent != null:
			reactive_changed.connect(parent._propagate)

		if Global.debug_reactive:
			print_rich("%s.parent = %s" % [self.repr, "<null>" if new_parent == null else new_parent.repr])

signal reactive_changed(reactive: Reactive)

func _init(parent_: Reactive = null) -> void:
  parent = parent_
  count += 1
  repr = "<reactive-%d>" % count

func _propagate(_reactive: Reactive = null) -> void:
	reactive_changed.emit(self)
	if Global.debug_reactive:
		print_rich("%s._propagate(%s)" % [self.repr, "<null>" if _reactive == null else _reactive.repr])

func manually_emit() -> void:
	reactive_changed.emit(self)
