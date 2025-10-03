extends CanvasLayer

var matter_boxes : Dictionary[Matter, BoxContainer]= {}

# FIXME: Need refactorization so I can understand it better.
# From https://gist.github.com/t-karcher/053b7097e744bc3ba4e1d20441ab72a7
func get_scientific_notation(number: float, precision: int = 99, use_engineering_notation: bool = false) -> String:
	var sign_ = sign(number)
	number = abs(number)
	if number < 1:
		var exp_ = step_decimals(number)
		if use_engineering_notation: exp_ = snapped(exp_ + 1, 3)
		var coeff = sign_ * number * pow(10, exp_)
		return str(snapped(coeff, pow(10, -precision))) + "e" + str(-exp_)
	elif number >= 10:
		var exp_ = str(number).split(".")[0].length() - 1
		if use_engineering_notation: exp_ = snapped(exp_ - 1, 3)
		var coeff = sign_ * number / pow(10, exp_)
		return str(snapped(coeff, pow(10, -precision))) + "e" + str(exp_)
	else:
		return str(snapped(sign_ * number, pow(10, -precision))) + "e0"

# Format numbers
func fnum(num : int) -> String:
	if num >= 10000:
		return get_scientific_notation(num, 2, false) # TODO: scientific, eng, etc.
	else:
		return str(num)

func get_box(mat : Matter) -> BoxContainer:
	return matter_boxes[mat]

func add_label(matter : Matter):
	# first we need an HBoxContainer.
	var hbox : HBoxContainer = HBoxContainer.new()
	hbox.name = matter.name.capitalize()

	# Save for updating.
	matter_boxes[matter] = hbox

	# then we need a left justified label for the name.
	var label : Label = Label.new()
	label.name = "name"
	label.set_text(matter.name.capitalize())
	label.set_h_size_flags(label.SIZE_EXPAND_FILL)
	hbox.add_child(label)

	# then we need a right justified label for the value.
	var value_label : Label = Label.new()
	value_label.name = "value"
	value_label.text = "0"
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.set_h_size_flags(label.SIZE_EXPAND_FILL)

	# NARF: Hook up reactive_changed for each ReactiveInt and then trigger it.

	hbox.add_child(value_label)

	# Add the hbox last, to prevent jiggling.
	%VBoxContainer.add_child(hbox)

func _ready() -> void:
	# Initialize Elements and Molecules.
	for matter: Matter in Matter.ALL:
		add_label(matter)

	State.matter.reactive_changed.connect(update_hud)
	update_hud()

func update_hud(matter: Matter = null) -> void:
	var to_update: Array[Matter]
	
	if matter == null:
		to_update = State.matter.matter()
	else:
		to_update = [matter]
	
	for mat : Matter in to_update:
		var amt : int = State.matter.get_int_by_key(mat)
		var box : BoxContainer = get_box(mat)
		var label : Label = box.get_node("value")

		print("NARF update_hud(): %s %s" % [ mat, amt])

		if amt > 0:
			label.text = fnum(amt)
			box.visible = true
		else:
			box.visible = false
