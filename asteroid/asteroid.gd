extends RigidBody2D

static var count : int = 0
# Has this asteroid been made visible?
var debuted : bool = false

var asteroid_size : AsteroidSize

var composition : MatterCollection = MatterCollection.new()

# Using ideas from https://www.iquilezles.org/www/articles/palettes/palettes.htm
func generate_colorscheme(n_colors : int, hue_diff : float = 0.9, saturation : float = 0.5) -> PackedColorArray:
#       var a = Vector3(rand_range(0.0, 0.5), rand_range(0.0, 0.5), rand_range(0.0, 0.5))
        var a = Vector3(0.5,0.5,0.5)
#       var b = Vector3(rand_range(0.1, 0.6), rand_range(0.1, 0.6), rand_range(0.1, 0.6))
        var b = Vector3(0.5,0.5,0.5) * saturation
        var c = Vector3(
          Global.rng.randf_range(0.5, 1.5),
          Global.rng.randf_range(0.5, 1.5),
          Global.rng.randf_range(0.5, 1.5)
        ) * hue_diff
        var d = Vector3(
          Global.rng.randf_range(0.0, 1.0),
          Global.rng.randf_range(0.0, 1.0),
          Global.rng.randf_range(0.0, 1.0)
        ) * Global.rng.randf_range(1.0, 3.0)

        var cols = PackedColorArray()
        var n = float(n_colors - 1.0)
        n = max(1, n)
        for i in range(0, n_colors, 1):
                var vec3 = Vector3()
                vec3.x = (a.x + b.x * cos(6.28318 * (c.x * float(i/n) + d.x)))
                vec3.y = (a.y + b.y * cos(6.28318 * (c.y * float(i/n) + d.y)))
                vec3.z = (a.z + b.z * cos(6.28318 * (c.z * float(i/n) + d.z)))

                cols.append(Color(vec3.x, vec3.y, vec3.z))

        return cols

func randomize_colors() -> Array[Color]:
  var seed_colors : PackedColorArray = generate_colorscheme(
    3,
    Global.rng.randf_range(0.3, 0.6),
    0.5
  )
  var cols : Array[Color] = []
  for i : int in 3:
    var new_col : Color = seed_colors[i].darkened(i/3.0)
    new_col = new_col.lightened((1.0 - (i/3.0)) * 0.2)

    cols.append(new_col)

  return cols

func _ready() -> void:
  asteroid_size = AsteroidSize.get_random_asteroid_size()
  inertia = 1000000.0 * asteroid_size.radius
  set_mass(1000.0 * asteroid_size.radius)

  var new_rotation_impulse : float = Global.rng.randf_range(-8.0, 8.0)
  apply_torque_impulse(new_rotation_impulse)

  # Composition
  composition.fill(1)

  # Image shape.
  var points = asteroid_size.generatePolygon()

  # Visible polygon shape
  var poly : Polygon2D = $Polygon2D
  poly.set_polygon(points)
  var mat: ShaderMaterial = poly.material
  mat.set_shader_parameter("seed", Global.rng.randf() * 1000 / 100.0)
  mat.set_shader_parameter("colors", randomize_colors())

  # Collision polygon shape.
  var collider : CollisionPolygon2D = $CollisionPolygon2D
  collider.set_polygon(points)

  count += 1

func be_absorbed() -> void:
  Global.collection.add_collection(composition)
  count -= 1

func die() -> void:
  count -= 1
  queue_free()

func _physics_process(_delta: float) -> void:
  if is_on_screen():
    if not debuted: debuted = true
  elif debuted:
      die()

# check if the position is within the viewport
func is_on_screen() -> bool:
  var screen : Vector2 = get_viewport().size
  var pos : Vector2 = position # position
  var fudge : float = 64 * 4

  return pos.y >= 0.0 - fudge && \
         pos.x >= 0.0 - fudge && \
         pos.x <= screen.x + fudge && \
         pos.y <= screen.y + fudge
