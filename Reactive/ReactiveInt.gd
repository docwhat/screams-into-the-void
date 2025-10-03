class_name ReactiveInt extends Reactive

func _init(value_: int, parent_: Reactive = null) -> void:
	super._init(parent_)
	value = value_

var value : int:
	set(v):
		value = v
		reactive_changed.emit(self)
		return value
