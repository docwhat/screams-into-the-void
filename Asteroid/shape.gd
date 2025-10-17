@tool
extends Polygon2D

var pixel_size: int = 3:
	get:
		return pixel_size
	set(value):
		if value != pixel_size:
			pixel_size = value
			update_texture()

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


## Returns a Rect2 describing a box that bounds the Polygon2D
func get_rect() -> Rect2:
	var rect = Rect2()
	for point: Vector2 in polygon:
		rect = rect.expand(point)
	return rect.abs()
