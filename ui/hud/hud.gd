extends CanvasLayer

var name_labels: Dictionary[Matter, Label] = { }
var value_labels: Dictionary[Matter, Label] = { }

var name_tweens: Dictionary[Matter, Tween] = { }
var value_tweens: Dictionary[Matter, Tween] = { }

@onready var grid_container: GridContainer = %GridContainer


## Adds the name and value label for a specific matter to the grid.
func add_label(matter: Matter):
	# Add name label.
	var name_label: Label = Label.new()
	name_label.name = "name_%s" % matter.symbol
	name_label.text = matter.preferred_name.capitalize()
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_labels[matter] = name_label

	# Add value label.
	var value_label: Label = Label.new()
	value_label.name = "value_%s" % matter.symbol
	value_label.text = "0"
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value_labels[matter] = value_label

	# Add to the grid.
	grid_container.add_child(name_label)
	grid_container.add_child(value_label)


func _ready() -> void:
	visible = false

	# Clear out any existing labels used for
	# for the 2d view in the editor.
	for child: Node in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()

	# Add labels for each matter type.
	for matter: Matter in Matter.all_matter:
		add_label(matter)

	GameSave.matter.matter_changed.connect(update_hud)

	# Wait a frame to ensure all nodes are ready.
	await Engine.get_main_loop().process_frame
	update_hud()


func update_hud(matter: Matter = null) -> void:
	var to_update: Array[Matter]
	var any_label_visible: bool = false

	if matter:
		to_update = [matter]
	else:
		to_update = Matter.all_matter.duplicate()

	for mat: Matter in to_update:
		var amt: int = GameSave.matter.get_by_matter(mat)
		var name_label: Label = name_labels[mat]
		var value_label: Label = value_labels[mat]

		if amt > 0:
			name_label.text = mat.preferred_name.capitalize()
			value_label.text = Global.format_number(amt)
			name_label.visible = true
			value_label.visible = true
			any_label_visible = true

			if name_tweens.get(mat):
				name_tweens[mat].kill()
			if value_tweens.get(mat):
				value_tweens[mat].kill()

			var name_tween: Tween = get_tree().create_tween()
			var value_tween: Tween = get_tree().create_tween()
			name_tweens[mat] = name_tween
			value_tweens[mat] = value_tween

			name_tween.tween_property(name_label, 'modulate', Color.YELLOW, 0.1)
			name_tween.tween_property(name_label, 'modulate', Color.WHITE, 0.9)

			value_tween.tween_property(value_label, 'modulate', Color.YELLOW, 0.1)
			value_tween.tween_property(value_label, 'modulate', Color.WHITE, 0.9)
		else:
			name_label.visible = false
			value_label.visible = false

	# Show ourself if any label is visible.
	visible = any_label_visible
