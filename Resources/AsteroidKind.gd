class_name AsteroidKind
extends Resource

@export var name: String
@export_multiline var notes: String
@export var probability: float = 1

var matter: MatterBag

@export_group("Colors", "color_")
@export_color_no_alpha var color_base_color: Color
@export_color_no_alpha var color_saturation: Color
@export_color_no_alpha var color_hue_diff: Color

# This can be rebuilt by dragging from the FileSystem panel.
const RES_PATHS: Array[String] = [
	"res://Resources/AsteroidKind/CarbonAsteroidKind.tres",
	"res://Resources/AsteroidKind/IceyAsteroidKind.tres",
	"res://Resources/AsteroidKind/IronAsteroidKind.tres",
	"res://Resources/AsteroidKind/MagnesiumAsteroidKind.tres",
	"res://Resources/AsteroidKind/OrganicAsteroidKind.tres",
	"res://Resources/AsteroidKind/StonyAsteroidKind.tres",
	"res://Resources/AsteroidKind/UraniumAsteroidKind.tres",
]
static var kinds: Array[AsteroidKind]


# Load up the kinds array.
static func _static_init() -> void:
	for path: String in RES_PATHS:
		kinds.append(load(path))


# Retrieve a random asteroid size.
static func random_kind() -> AsteroidKind:
	if kinds.size() == 0:
		return null

	var weights: PackedFloat32Array

	for kind: AsteroidKind in kinds:
		weights.push_back(kind.probability)

	var random_index = Global.rng.rand_weighted(weights)
	return kinds[random_index]


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
