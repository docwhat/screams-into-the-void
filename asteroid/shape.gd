@tool
extends Polygon2D

var pixel_size: int = 3:
	get:
		return pixel_size
	set(value):
		if value != pixel_size:
			pixel_size = value
			update_texture()

var color_dark: Color = Color("#008800"):
	get:
		return color_dark
	set(value):
		if value != color_dark:
			color_dark = value
			update_texture()
var color_mid: Color = Color("#00ff00"):
	get:
		return color_mid
	set(value):
		if value != color_mid:
			color_mid = value
			update_texture()
var color_light: Color = Color("#88ff88"):
	get:
		return color_light
	set(value):
		if value != color_light:
			color_light = value
			update_texture()

## The source of noise for the texture.
var noise: FastNoiseLite


func update_texture() -> void:
	# A square that covers the shape.
	var rect: Rect2 = get_rect()
	var square: int = ceil(maxf(rect.size.x, rect.size.y))

	var image: Image = make_asteroid_texture(square, square)

	# Create the ImageTexture from the generated Image
	self.texture = ImageTexture.create_from_image(image)
	self.texture_offset = Vector2(square / 2.0, square / 2.0)


# Fractal Brownian Motion noise generator
func fbm(x: int, y: int) -> float:
	if not noise:
		noise = FastNoiseLite.new()
		noise.seed = Global.rng.randi()

		noise.fractal_type = FastNoiseLite.FRACTAL_FBM
		noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
		noise.fractal_octaves = 5
		noise.fractal_lacunarity = 2.0

	return (noise.get_noise_2d(x, y) + 1.0) / 2.0


func make_asteroid_texture(width: int, height: int) -> Image:
	# Create a new Image to draw on
	var image: Image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	surface_noise(image)

	add_craters(image)

	return image


## Unfilled circle (optionally a ring with `thickness` pixels).
func circle(
		image: Image,
		center: Vector2,
		radius: int,
		the_color: Color,
		thickness: int = 1,
) -> void:
	var width: int = image.get_width()
	var height: int = image.get_height()

	# Ensure sensible thickness
	if thickness <= 1:
		# Original behaviour: single-pixel circumference
		for angle_deg: int in range(0, 360):
			var angle_rad: float = deg_to_rad(float(angle_deg))
			var x_offset: int = int(radius * cos(angle_rad))
			var y_offset: int = int(radius * sin(angle_rad))
			var x: int = int(center.x) + x_offset
			var y: int = int(center.y) + y_offset
			if x >= 0 and x < width and y >= 0 and y < height:
				image.set_pixel(x, y, image.get_pixel(x, y).blend(the_color))
	else:
		# Draw multiple concentric circles to achieve a ring with the requested thickness.
		# Center thickness about the given radius: e.g. thickness 3 => r-1..r+1
		var half: int = int(thickness / 2.0)
		var start_r: int = max(0, radius - half)
		var end_r: int = radius + (thickness - half - 1)

		for angle_deg: int in range(0, 360):
			var angle_rad: float = deg_to_rad(float(angle_deg))
			for r: int in range(start_r, end_r + 1):
				var x_offset: int = int(r * cos(angle_rad))
				var y_offset: int = int(r * sin(angle_rad))
				var x: int = int(center.x) + x_offset
				var y: int = int(center.y) + y_offset
				if x >= 0 and x < width and y >= 0 and y < height:
					image.set_pixel(x, y, image.get_pixel(x, y).blend(the_color))


func filled_circle(image: Image, center: Vector2, radius: int, the_color: Color) -> void:
	var width: int = image.get_width()
	var height: int = image.get_height()

	for x_offset: int in range(-radius, radius + 1):
		for y_offset: int in range(-radius, radius + 1):
			if x_offset * x_offset + y_offset * y_offset <= radius * radius:
				var x: int = int(center.x) + x_offset
				var y: int = int(center.y) + y_offset
				if x >= 0 and x < width and y >= 0 and y < height:
					image.set_pixel(x, y, image.get_pixel(x, y).blend(the_color))


## draws craters on the image
func add_craters(image: Image) -> Image:
	var width: int = image.get_width()
	var height: int = image.get_height()

	# Add a number of craters relative to the size of the image
	var num_craters: int = maxi(1, int((width + height) / 20.0))

	for i: int in range(num_craters):
		# Random position for the crater
		var crater_x: int = Global.rng.randi_range(0, width - 1)
		var crater_y: int = Global.rng.randi_range(0, height - 1)

		# Random radius for the crater
		var crater_radius: int = Global.rng.randi_range(
			4,
			mini(floor(maxi(height, width) * 0.1), 14),
		)

		# Darked the color and shift it towards yellowish
		var shadow: Color = color_dark.darkened(0.4)
		shadow.a = Global.rng.randf_range(0.1, 0.4)

		# Lightened the color and shift it towards blue/purple
		var highlight: Color = color_light.lightened(0.4)
		highlight.a = Global.rng.randf_range(0.5, 0.8)

		var thickness: int = Global.rng.randi_range(1, 3)

		# Light highlight
		filled_circle(
			image,
			Vector2(crater_x, crater_y),
			crater_radius - thickness,
			highlight,
		)

		# Dark shadow
		circle(
			image,
			Vector2(crater_x, crater_y),
			crater_radius,
			shadow,
			thickness,
		)

	return image


func surface_noise(image: Image) -> Image:
	var width: int = image.get_width()
	var height: int = image.get_height()

	# Iterate over each pixel to set its color based on noise
	for x: int in range(width):
		for y: int in range(height):
			# Round to nearest pixel_size.
			var x_pos: int = int((float(x) / pixel_size)) * pixel_size
			var y_pos: int = int((float(y) / pixel_size)) * pixel_size

			var noise_value: float = fbm(x_pos, y_pos)

			const LIGHT_BOUNDARY: float = 0.4
			const DARK_BOUNDARY: float = 0.6
			const BOUNDARY_SIZE: float = 0.05

			var the_color: Color
			if noise_value < LIGHT_BOUNDARY or noise_value < (LIGHT_BOUNDARY + BOUNDARY_SIZE):
				the_color = color_dark
			elif noise_value > DARK_BOUNDARY or noise_value > (DARK_BOUNDARY + BOUNDARY_SIZE):
				the_color = color_light
			else:
				the_color = color_mid

			image.set_pixel(x, y, the_color)

	return image


## Returns a Rect2 describing a box that bounds the Polygon2D
func get_rect() -> Rect2:
	var rect: Rect2 = Rect2()
	for point: Vector2 in polygon:
		rect = rect.expand(point)
	return rect.abs()
