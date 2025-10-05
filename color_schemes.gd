extends Node

## One dimensional palette_float function from
## https://iquilezles.org/articles/palettes/
func palette_float(a: float, b: float, c: float, d: float, t: float) -> float:
	return a + b * cos(2.0 * PI * (c * t + d))


func phase_shift(a: Color, b: Color, c: Color, d: Color, t: float) -> Color:
	return Color(
		ColorSchemes.palette_float(a.r, b.r, c.r, d.r, t),
		ColorSchemes.palette_float(a.g, b.g, c.g, d.g, t),
		ColorSchemes.palette_float(a.b, b.b, c.b, d.b, t),
	)


func to_ok_hsl(c: Color) -> String:
	var h = c.ok_hsl_h
	var s = c.ok_hsl_s
	var l = c.ok_hsl_l
	return "(%.2f %.0f%% %.0f%%)" % [h, s * 100.0, l * 100.0]


func recolor(clr: Color) -> Color:
	clr = Color(clr)
	clr.ok_hsl_s = min(clr.ok_hsl_s, 0.75)
	clr.ok_hsl_l = clampf(clr.ok_hsl_l, 0.05, 0.8)
	return clr


func threecolor() -> PackedColorArray:
	var colors: PackedColorArray

	var a = Color(Global.rng.randf(), Global.rng.randf(), Global.rng.randf())
	var b = Color(a)
	var c = Color(a)

	b.ok_hsl_h = b.ok_hsl_h + 150.0 / 360.0
	c.ok_hsl_h = c.ok_hsl_h + 210.0 / 360.0

	colors.append(recolor(a))
	colors.append(recolor(b))
	colors.append(recolor(c))

	return colors
	# vector a = rand(0, seed)
	# vector b = rand(1, seed)

	# a = recolor(a)
	# b = recolor(b)

	# int class = i@primnum % 3
	# if(class == 1) b = a
	# if(class == 2) a = b

	# v@Cd = min(a, b) / pow(max(a, b), 0.25)


## Using ideas from https://www.iquilezles.org/www/articles/palettes/palettes.htm
func generate_colorscheme(
		n_colors: int,
		hue_diff: float = 0.9,
		saturation: float = 0.5,
) -> PackedColorArray:
	# var a = Color(randf_range(0.0, 0.5), randf_range(0.0, 0.5), randf_range(0.0, 0.5))
	var a = Color(0.5, 0.5, 0.5)
	# var b = Color(randf_range(0.1, 0.6), randf_range(0.1, 0.6), randf_range(0.1, 0.6))
	var b = Color(0.5, 0.5, 0.5) * saturation
	var c = Color(
		Global.rng.randf_range(0.5, 1.5),
		Global.rng.randf_range(0.5, 1.5),
		Global.rng.randf_range(0.5, 1.5),
	) * hue_diff
	var d = Color(
		Global.rng.randf_range(0.0, 1.0),
		Global.rng.randf_range(0.0, 1.0),
		Global.rng.randf_range(0.0, 1.0),
	) * Global.rng.randf_range(1.0, 3.0)

	var cols: PackedColorArray = PackedColorArray()
	var n: float = max(1.0, float(n_colors - 1.0))
	for i: int in range(0, n_colors, 1):
		var t: float = float(i) / n
		var color = Color(
			palette_float(a.r, b.r, c.r, d.r, t),
			palette_float(a.g, b.g, c.g, d.g, t),
			palette_float(a.b, b.b, c.b, d.b, t),
		)
		cols.append(color)

	if Global.debug_asteroid_colors:
		print_rich(
			"floats: %s %s %s %s" % [
				to_ok_hsl(a),
				to_ok_hsl(b),
				to_ok_hsl(c),
				to_ok_hsl(d),
			],
		)
		print_rich(
			"scheme: %s %s %s" % [
				to_ok_hsl(cols[0]),
				to_ok_hsl(cols[1]),
				to_ok_hsl(cols[2]),
			],
		)
	return cols


## Returns a set of related colors.
func randomize_colors(count: int = 3) -> Array[Color]:
	var seed_colors: PackedColorArray = generate_colorscheme(
		3,
		Global.rng.randf_range(0.3, 0.6),
		0.5,
	)
	var cols: Array[Color] = []
	for i: int in count:
		var new_col: Color = seed_colors[i].darkened(i / float(count))
		new_col = new_col.lightened((1.0 - (i / float(count))) * 0.2)

		cols.append(new_col)

	return cols

# color0
#   darkened(0/3 = 0)
#   lightened(1 - 0 * 0.6 = 1)
# color1
#   darkened(1/3 = 0.33)
#   lightened(1 - 1 * 0.6 = 0.933)
# color2
#   darkened(2/3 = 0.66)
#   lightened(1 - 2/3 * 0.22 = 0.866)
