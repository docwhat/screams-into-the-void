extends CanvasLayer

const Matter = MatterCollection.Matter

var value_labels = {}

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

func _ready() -> void:
  # Add all the matter items.
  for matter_name in Matter.keys():
    # first we need an HBoxContainer.
    var hbox : HBoxContainer = HBoxContainer.new()
    hbox.name = matter_name.capitalize()

    # then we need a left justified label for the name.
    var label : Label = Label.new()
    label.name = "name"
    label.set_text(matter_name.capitalize())
    label.set_h_size_flags(label.SIZE_EXPAND_FILL)
    hbox.add_child(label)

    # then we need a right justified label for the value.
    var value_label : Label = Label.new()
    value_label.name = "value"
    value_label.set_text("0")
    value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
    value_label.set_h_size_flags(label.SIZE_EXPAND_FILL)

    # Save for updating.
    value_labels[matter_name] = value_label
    hbox.add_child(value_label)

    # Add the hbox last, to prevent jiggling.
    %VBoxContainer.add_child(hbox)

  # TODO: The HUD isn't vertically resizing based on the contents.
  # TODO: The HUD isn't horizontally resizing based on the contents.
  update_hud()

func update_hud() -> void:
  for matter_name in Matter.keys():
    var label : Label = value_labels[matter_name]
    var value : int = Global.collection.get_by_string(matter_name)
    label.text = fnum(value)
