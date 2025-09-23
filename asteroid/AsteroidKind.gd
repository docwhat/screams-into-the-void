class_name AsteroidKind

const Matter = MatterCollection.Matter

static var CarbonAsteroidKind : AsteroidKind
static var IceyAsteroidKind : AsteroidKind
static var OrganicAsteroidKind : AsteroidKind
static var UraniumAsteroidKind : AsteroidKind
static var StonyAsteroidKind : AsteroidKind
static var MagnesiumAsteroidKind : AsteroidKind
static var IronAsteroidKind : AsteroidKind

# Stores all asteroid kinds.
static var ALL_KINDS : Array[AsteroidKind] = []

static func _static_init() -> void:
  ##############################################
  # Black colored. Lots of carbon
  CarbonAsteroidKind = AsteroidKind.new("CarbonAsteroidKind")
  CarbonAsteroidKind.probability = 0.1
  CarbonAsteroidKind.matter = [Matter.CARBON]
  ALL_KINDS.push_back(CarbonAsteroidKind)

  ##############################################
  # Blue colored. Lots of water and bits of things like copper.
  IceyAsteroidKind = AsteroidKind.new("IceyAsteroidKind")
  IceyAsteroidKind.probability = 0.1
  IceyAsteroidKind.matter = [Matter.WATER, Matter.COPPER]
  ALL_KINDS.push_back(IceyAsteroidKind)

  ##############################################
  # Brown colored. Contains silicon, carbon, water, nitrogen, sulfur.
  OrganicAsteroidKind = AsteroidKind.new("OrganicAsteroidKind")
  OrganicAsteroidKind.probability = 0.1
  OrganicAsteroidKind.matter = [Matter.SILICON, Matter.CARBON, Matter.WATER]
  ALL_KINDS.push_back(OrganicAsteroidKind)

  ##############################################
  # Green colored. Contains Uranium.
  UraniumAsteroidKind = AsteroidKind.new("UraniumAsteroidKind")
  UraniumAsteroidKind.probability = 0.1
  UraniumAsteroidKind.matter = [Matter.URANIUM]
  ALL_KINDS.push_back(UraniumAsteroidKind)

  ##############################################
  # White colored. Contains silicon and magnesium
  StonyAsteroidKind = AsteroidKind.new("StonyAsteroidKind")
  StonyAsteroidKind.probability = 0.1
  StonyAsteroidKind.matter = [Matter.SILICON, Matter.MAGNESIUM]
  ALL_KINDS.push_back(StonyAsteroidKind)

  ##############################################
  # Red/Yellow colored. Contains magnesium.
  MagnesiumAsteroidKind = AsteroidKind.new("MagnesiumAsteroidKind")
  MagnesiumAsteroidKind.probability = 0.1
  MagnesiumAsteroidKind.matter = [Matter.MAGNESIUM]
  ALL_KINDS.push_back(MagnesiumAsteroidKind)

  ##############################################
  # Gray colored. Contains iron & nickel.
  IronAsteroidKind = AsteroidKind.new("IronAsteroidKind")
  IronAsteroidKind.probability = 0.1
  IronAsteroidKind.matter = [Matter.IRON, Matter.NICKEL]
  ALL_KINDS.push_back(IronAsteroidKind)

var probability : float = 1

var matter : Array[Matter]

var name : String

var base_color : Color
var saturation : Color
var hue_diff : Color

func _init(name_: String):
  self.name = name_

# Retrieve a random asteroid size.
static func random_kind() -> AsteroidKind:
  if ALL_KINDS.size() == 0:
    return null

  var weights : PackedFloat32Array

  for size in ALL_KINDS:
    weights.push_back(size.probability)

  var random_index = Global.rng.rand_weighted(weights)
  return ALL_KINDS[random_index]

func palette() -> PackedColorArray:
  var n_colors : int = 3

  # Hack for setting the base colors.
  CarbonAsteroidKind.base_color = ColorSchemes.CarbonAsteroidColor
  CarbonAsteroidKind.saturation = ColorSchemes.CarbonAsteroidSaturation
  CarbonAsteroidKind.hue_diff = ColorSchemes.CarbonAsteroidHueDiff

  IceyAsteroidKind.base_color = ColorSchemes.IceyAsteroidColor
  IceyAsteroidKind.saturation = ColorSchemes.IceyAsteroidSaturation
  IceyAsteroidKind.hue_diff = ColorSchemes.IceyAsteroidHueDiff

  OrganicAsteroidKind.base_color = ColorSchemes.OrganicAsteroidColor
  OrganicAsteroidKind.saturation = ColorSchemes.OrganicAsteroidSaturation
  OrganicAsteroidKind.hue_diff = ColorSchemes.OrganicAsteroidHueDiff

  UraniumAsteroidKind.base_color = ColorSchemes.UraniumAsteroidColor
  UraniumAsteroidKind.saturation = ColorSchemes.UraniumAsteroidSaturation
  UraniumAsteroidKind.hue_diff = ColorSchemes.UraniumAsteroidHueDiff

  StonyAsteroidKind.base_color = ColorSchemes.StonyAsteroidColor
  StonyAsteroidKind.saturation = ColorSchemes.StonyAsteroidSaturation
  StonyAsteroidKind.hue_diff = ColorSchemes.StonyAsteroidHueDiff

  MagnesiumAsteroidKind.base_color = ColorSchemes.MagnesiumAsteroidColor
  MagnesiumAsteroidKind.saturation = ColorSchemes.MagnesiumAsteroidSaturation
  MagnesiumAsteroidKind.hue_diff = ColorSchemes.MagnesiumAsteroidHueDiff

  IronAsteroidKind.base_color = ColorSchemes.IronAsteroidColor
  IronAsteroidKind.saturation = ColorSchemes.IronAsteroidSaturation
  IronAsteroidKind.hue_diff = ColorSchemes.IronAsteroidHueDiff

  var a : Color = base_color
  var b : Color = saturation
  var c : Color = hue_diff
  var d : Color = Color(
    Global.rng.randf_range(0.0, 1.0),
    Global.rng.randf_range(0.0, 1.0),
    Global.rng.randf_range(0.0, 1.0)
  ) * Global.rng.randf_range(1.0, 3.0)

  var cols : PackedColorArray = PackedColorArray()
  var n : float = max(1.0, float(n_colors - 1.0))

  for i in range(0, n_colors, 1):
    var t : float = float(i) / n
    var new_col : Color = ColorSchemes.phase_shift(a, b, c, d, t)
    new_col = new_col.darkened(t * 0.9)
    new_col = new_col.lightened((1.0 - t) * 0.2)
    cols.append(new_col.clamp())

  if Global.debug_asteroid_colors:
    print("== ", name, " ==")
    print_color("bas", base_color)
    print_color("sat", saturation)
    print_color("hue", hue_diff)
    print()
    print_color("0", cols[0])
    print_color("1", cols[1])
    print_color("2", cols[2])

  return cols

func print_color(n : String, c : Color) -> void:
  if not Global.debug_asteroid_colors: return

  var h : String = "#" + c.to_html(true)
  print_rich("   %3s  [b]%s[/b]  [bgcolor=%s]      [/bgcolor]  Color(%f, %f, %f)" % [n, h, h, c.r, c.g, c.b])

func random_matter(size: AsteroidSize) -> MatterCollection:
  var matter_collection = MatterCollection.new()
  var max_amount : float = size.radius / 8.0


  if Global.debug_asteroid_kind:
    print_rich("[b]== %s (%f) ==[/b]" % [name, size.radius])
  for m : Matter in matter:
    var amount : int = floor(max_amount * Global.rng.randf())
    matter_collection.set_amount(m, amount)
    if Global.debug_asteroid_kind:
      print_rich("   %10s: %-5d" % [MatterCollection.AntiMatter[m], amount])

  return matter_collection

# EOF
