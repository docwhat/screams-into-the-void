extends CanvasLayer

var matter_boxes: Dictionary[Matter, HBoxContainer] = { }
var update_tweens: Dictionary[Matter, Tween] = { }


func get_box(mat: Matter) -> HBoxContainer:
	return matter_boxes[mat]


func add_label(matter: Matter):
	# first we need an HBoxContainer.
	var hbox: HBoxContainer = HBoxContainer.new()
	hbox.name = matter.name.capitalize()
	hbox.visible = false

	# Save for updating.
	matter_boxes[matter] = hbox

	# then we need a left justified label for the name.
	var label: Label = Label.new()
	label.name = "name"
	label.text = matter.preferred_name.capitalize()
	label.set_h_size_flags(label.SIZE_EXPAND_FILL)
	hbox.add_child(label)

	# then we need a right justified label for the value.
	var value_label: Label = Label.new()
	value_label.name = "value"
	value_label.text = "0"
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.set_h_size_flags(label.SIZE_EXPAND_FILL)

	hbox.add_child(value_label)

	# Add the hbox last, to prevent jiggling.
	%VBoxContainer.add_child(hbox)


func _ready() -> void:
	$".".visible = false

	for matter: Matter in Matter.all_matter:
		add_label(matter)

	State.matter.matter_changed.connect(update_hud)
	update_hud()


func update_hud(matter: Matter = null) -> void:
	var to_update: Array[Matter]
	var any_visible: bool = false

	if matter:
		to_update = [matter]
	else:
		to_update = Matter.all_matter.duplicate()

	for mat: Matter in to_update:
		var amt: int = State.matter.get_by_matter(mat)
		var box: HBoxContainer = get_box(mat)
		var value_label: Label = box.get_node("value")
		var name_label: Label = box.get_node("name")

		if amt > 0:
			name_label.text = mat.preferred_name.capitalize()
			value_label.text = NumberTools.fnum(amt)
			box.visible = true
			any_visible = true

			if update_tweens.get(mat):
				update_tweens[mat].kill()

			update_tweens[mat] = get_tree().create_tween()
			update_tweens[mat].tween_property(box, 'modulate', Color.YELLOW, 0.1)
			update_tweens[mat].tween_property(box, 'modulate', Color.WHITE, 0.9)

		else:
			box.visible = false

	if any_visible:
		$".".visible = true
