@tool
class_name AsteroidKind
extends Resource
## What kind of Asteroid is it?
##
## This represents the composition of the Asteroid.

@export var name: String
@export_multiline var notes: String
@export var probability: float = 1

var matter: MatterBag

@export_group("Colors", "color_")
@export_color_no_alpha var color_base_color: Color
@export_color_no_alpha var color_saturation: Color
@export_color_no_alpha var color_hue_diff: Color

static var kinds: Array[AsteroidKind]

static var _is_loaded: bool = false


## Load the AsteroidKind resources dynamically from disk.
static func load_resources() -> void:
	if _is_loaded:
		return
	var resources: Array[AsteroidKind] = []
	var file_paths: Array[String] = ResourceTools.find_resources("res://Asteroid/AsteroidKind")

	for file_path: String in file_paths:
		var res: AsteroidKind = load(file_path)
		if res:
			resources.append(res)
		else:
			push_error("Failed to load resource  AsteroidKind from %s" % [file_path])

	kinds = resources
	_is_loaded = true


## Retrieve a random asteroid kind.
static func random_kind() -> AsteroidKind:
	load_resources()

	if kinds.size() == 0:
		return null

	var kind_weights: PackedFloat32Array = []

	for kind: AsteroidKind in kinds:
		kind_weights.push_back(kind.probability)

	var random_index: int = Global.rng.rand_weighted(kind_weights)
	return kinds[random_index]


func _init() -> void:
	if not matter:
		matter = MatterBag.new()
	# Ensure property list is updated when matter is initialized
	if Engine.is_editor_hint():
		notify_property_list_changed()


## This is used to expose each Matter as a property in the editor, so we can set
## the amount of each matter in this asteroid kind.
##
## The property name is "matter_<matter name>".
## The properties are grouped under "matter".
func _get_property_list() -> Array[Dictionary]:
	var props: Array[Dictionary] = []

	# Add all the matter types as integer properties.
	for mat: Matter in Global.matter.all:
		var prop: Dictionary = {
			"name": "matter/%s" % mat.name,
			"type": TYPE_INT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,300.0,1",
			"usage": PROPERTY_USAGE_DEFAULT,
		}
		props.append(prop)

	return props


## Get the amount of a specific matter, by property name.
##
## If the property is a matter property, return the value from the matter
## bag.
##
## Return 0 if we aren't handling this property.
func _get(property: StringName) -> Variant:
	if property.begins_with("matter/"):
		var mat_name: StringName = property.get_slice("/", 1)
		if mat_name and Global.matter.by_name.has(mat_name):
			return matter.get_by_name(mat_name)

	return null


## Set the amount of a specific matter, by property name.
##
## If the property is a matter property, set the value in the matter
## bag.
##
## Return true if we handled this property, false otherwise.
func _set(property: StringName, value: Variant) -> bool:
	if property.begins_with("matter/"):
		var mat_name: StringName = property.get_slice("/", 1)
		if mat_name and Global.matter.by_name.has(mat_name):
			matter.set_by_name(mat_name, int(value))
			return true
	return false


func palette() -> PackedColorArray:
	var n_colors: int = 3

	var a: Color = color_base_color
	var b: Color = color_saturation
	var c: Color = color_hue_diff
	var d: Color = Color(
		Global.rng.randf_range(0.0, 1.0),
		Global.rng.randf_range(0.0, 1.0),
		Global.rng.randf_range(0.0, 1.0),
	) * Global.rng.randf_range(1.0, 3.0)

	var cols: PackedColorArray = PackedColorArray()
	var n: float = max(1.0, float(n_colors - 1.0))

	for i: int in range(0, n_colors, 1):
		var t: float = float(i) / n
		var new_col: Color = ColorSchemes.phase_shift(a, b, c, d, t)
		new_col = new_col.darkened(t * 0.9)
		new_col = new_col.lightened((1.0 - t) * 0.2)
		cols.append(new_col.clamp())

	if Global.debug_asteroid_colors:
		print("== ", name, " ==")
		print_color("bas", color_base_color)
		print_color("sat", color_saturation)
		print_color("hue", color_hue_diff)
		print()
		print_color("0", cols[0])
		print_color("1", cols[1])
		print_color("2", cols[2])

	return cols


func print_color(n: String, c: Color) -> void:
	if not Global.debug_asteroid_colors:
		return

	var h: String = "#" + c.to_html(true)
	print_rich(
		"   %3s  [b]%s[/b]  [bgcolor=%s]      [/bgcolor]  Color(%f, %f, %f)" % [
			n,
			h,
			h,
			c.r,
			c.g,
			c.b,
		],
	)


func configure_shader(material: ShaderMaterial) -> void:
	material.set_shader_parameter("colors", palette())

# EOF
