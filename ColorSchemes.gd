extends Node

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

# Returns a set of related colors.
func randomize_colors(count : int = 3) -> Array[Color]:
  var seed_colors : PackedColorArray = generate_colorscheme(
    3,
    Global.rng.randf_range(0.3, 0.6),
    0.5
  )
  var cols : Array[Color] = []
  for i : int in count:
    var new_col : Color = seed_colors[i].darkened(i/float(count))
    new_col = new_col.lightened((1.0 - (i/float(count))) * 0.2)

    cols.append(new_col)

  return cols
