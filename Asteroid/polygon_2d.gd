extends Polygon2D

var pixel_size: int = 3:
	get:
		return pixel_size
	set(value):
		if value != pixel_size:
			pixel_size = value
			update_texture()

var colors: PackedColorArray:
	set(value):
		color_dark = value[0]
		color_mid = value[1]
		color_light = value[2]
	get:
		return PackedColorArray([color_dark, color_mid, color_light])

var color_dark = Color("#008800"):
	get:
		return color_dark
	set(value):
		if value != color_dark:
			color_dark = value
			update_texture()
var color_mid = Color("#00ff00"):
	get:
		return color_mid
	set(value):
		if value != color_mid:
			color_mid = value
			update_texture()
var color_light = Color("#88ff88"):
	get:
		return color_light
	set(value):
		if value != color_light:
			color_light = value
			update_texture()

var noise_type: FastNoiseLite.NoiseType = FastNoiseLite.TYPE_SIMPLEX:
	get:
		return noise_type
	set(value):
		if value != noise_type:
			noise_type = value
			update_texture()

var noise_frequency: float = 0.01:
	get:
		return noise_frequency
	set(value):
		if value != noise_frequency:
			noise_frequency = value
			update_texture()

var noise_fractal_octaves: int = 4:
	get:
		return noise_fractal_octaves
	set(value):
		if value != noise_fractal_octaves:
			noise_fractal_octaves = value
			update_texture()

var noise_fractal_gain: float = 0.01:
	get:
		return noise_fractal_gain
	set(value):
		if value != noise_fractal_gain:
			noise_fractal_gain = value
			update_texture()

var noise_fractal_lacunarity: float = 25.0:
	get:
		return noise_fractal_lacunarity
	set(value):
		if value != noise_fractal_lacunarity:
			noise_fractal_lacunarity = value
			update_texture()

var noise: FastNoiseLite = FastNoiseLite.new()


func _ready():
	noise.seed = Global.rng.randi()


func update_texture():
	noise.fractal_octaves = noise_fractal_octaves
	noise.fractal_lacunarity = noise_fractal_lacunarity
	noise.noise_type = noise_type
	noise.frequency = noise_frequency
	noise.fractal_gain = noise_fractal_gain

	var rect: Rect2 = get_rect()
	var square: int = ceil(maxf(rect.size.x, rect.size.y))

	# Create a new Image to draw on
	var image = Image.create(square, square, false, Image.FORMAT_RGBA8)

	# Iterate over each pixel to set its color based on noise
	for x: int in range(square):
		for y: int in range(square):
			# Round to nearest pixel_size.
			var x_pos: int = int((float(x) / pixel_size)) * pixel_size
			var y_pos: int = int((float(y) / pixel_size)) * pixel_size

			var noise_value = noise.get_noise_2d(x_pos, y_pos)

			var the_color: Color
			if noise_value < -0.3:
				the_color = color_dark
			elif noise_value > 0.3:
				the_color = color_light
			else:
				the_color = color_mid

			if x == square - 1 or y == square - 1 or x == 0 or y == 0:
				the_color = Color(0, 0, 0, 0)

			image.set_pixel(x, y, the_color)

	# Create the ImageTexture from the generated Image
	self.texture = ImageTexture.create_from_image(image)
	self.texture_offset = Vector2(square / 2.0, square / 2.0)

	## Set up UV mapping for the Polygon2D
	#setup_uv_mapping()

	### Map all point coordinates to a scale between 0.0, and 1.0.
	#func setup_uv_mapping():
	## Get the bounding rectangle of the polygon
	#var rect: Vector2 = get_rectangular_size()
	#print("NARF: %s" % [rect])
	#
	## Create a new UV array
	#var uvs: PackedVector2Array = []
	#
	#for vertex: Vector2 in polygon:
	#var new_uv: Vector2 = Vector2(
	#(vertex.x + rect.x / 2.0) / rect.x,
	#(vertex.y + rect.y / 2.0) / rect.y,
	#)
	## (vertex + Vector2(rect) / 2.0) / Vector2(rect)
	##var uv_x = vertex.x / rect.x + 1.0
	##var uv_y = vertex.y / rect.y + 1.0
	##uvs.append(Vector2(uv_x, uv_y))
	#uvs.append(new_uv)
	#var problem: bool = new_uv.x > 1.0 or new_uv.x < 0.0 or new_uv.y > 1.0 or new_uv.y < 0.0
	#print("      %s / %s + 1 = %s   %s" % [vertex, rect, new_uv, problem])
	#
	#self.uv = uvs

	### Calculates the height and width of a box that would contain the Polygon2D
	###
	### This does not guarantee the box is minimal, though.
	#func get_rectangular_size1() -> Vector2:
	#var rect: Vector2 = Vector2(0,0)
	#
	#for point: Vector2 in polygon:
	#rect.x = maxf(rect.x, absf(point.x) * 2)
	#rect.y = maxf(rect.y, absf(point.y) * 2)
	#
	#return rect


func get_rect() -> Rect2:
	var rect = Rect2()
	for point: Vector2 in polygon:
		rect = rect.expand(point)
	return rect.abs()
