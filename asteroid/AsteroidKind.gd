class_name AsteroidKind

static var CarbonAsteroidKind : AsteroidKind
static var IceyAsteroidKind : AsteroidKind
static var OrganicAsteroidKind : AsteroidKind
static var UraniumAsteroidKind : AsteroidKind
static var StonyAsteroidKind : AsteroidKind
static var MagnesiumAsteroidKind : AsteroidKind
static var IronAsteroidKind : AsteroidKind


# Stores all asteroid kinds.
static var ALL_KINDS : Array[AsteroidKind] = []

static func _static_init():
  ##############################################
  # Black colored. Lots of carbon
  CarbonAsteroidKind = AsteroidKind.new()
  CarbonAsteroidKind.probability = 0.1
  ALL_KINDS.push_back(CarbonAsteroidKind)

  ##############################################
  # Blue colored. Lots of water and bits of things like copper.
  IceyAsteroidKind = AsteroidKind.new()
  IceyAsteroidKind.probability = 0.1
  ALL_KINDS.push_back(IceyAsteroidKind)

  ##############################################
  # Brown colored. Contains silicon, carbon, water, nitrogen, sulfur.
  OrganicAsteroidKind = AsteroidKind.new()
  OrganicAsteroidKind.probability = 0.1
  ALL_KINDS.push_back(OrganicAsteroidKind)

  ##############################################
  # Green colored. Contains Uranium.
  UraniumAsteroidKind = AsteroidKind.new()
  UraniumAsteroidKind.probability = 0.1
  ALL_KINDS.push_back(UraniumAsteroidKind)

  ##############################################
  # White colored. Contains silicon and magnesium
  StonyAsteroidKind = AsteroidKind.new()
  StonyAsteroidKind.probability = 0.1
  ALL_KINDS.push_back(StonyAsteroidKind)

  ##############################################
  # Red/Yellow colored. Contains magnesium.
  MagnesiumAsteroidKind = AsteroidKind.new()
  MagnesiumAsteroidKind.probability = 0.1
  ALL_KINDS.push_back(MagnesiumAsteroidKind)

  ##############################################
  # Gray colored. Contains iron & nickel.
  IronAsteroidKind = AsteroidKind.new()
  IronAsteroidKind.probability = 0.1
  ALL_KINDS.push_back(IronAsteroidKind)
  
static var probability : float = 1

# Retrieve a random asteroid size.
static func random_kind() -> AsteroidKind:
  var weights : PackedFloat32Array

  for size in ALL_KINDS:
    weights.push_back(size.probability)

  var random_index = Global.rng.rand_weighted(weights)
  return ALL_KINDS[random_index]

# EOF
