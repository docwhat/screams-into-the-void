class_name AsteroidSize

# Base radius of the asteroid.
var radius : float

# Maximum change to the radius of the asteroid.
var max_radius_delta : float

# Used to calculate what the probability of an asteroid being spawned is.
var probability : float

func _init(r : float, d : float, p: float) -> void:
    radius = r
    max_radius_delta = d
    probability = p

# Generate a set of points describing an asteroid of this size.
func generatePolygon() -> PackedVector2Array:
  # Pick an random number of points. More is smoother.
  var number_of_points : int = Global.rng.randi_range(5, 12)

  var polygon : PackedVector2Array
  # First point at the chosen radius.
  polygon.append(Vector2(radius, 0))

  # The algorithm is to just go around a circle at evenly spaced points at random radii.
  for point in range(1, number_of_points):
    # Randomize the radius.
    var rad : float = Global.rng.randf_range(
      radius - Global.rng.randf_range(0.0, max_radius_delta),
      radius + Global.rng.randf_range(0.0, max_radius_delta)
    )

    # calculate angle (evenly spaced).
    var angle : float = point * PI * 2 / number_of_points
    polygon.append(Vector2(rad, 0).rotated(angle))

  return polygon
