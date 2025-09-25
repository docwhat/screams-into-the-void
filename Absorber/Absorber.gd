class_name Absorber

static func get_name() -> String:
  return "The perfect processor"

static func get_description() -> String:
  return "Processes and absorbs 100% of all resources."

# A non-limiter. Override to behave differently.
static func limit_one(_mat: MatterCollection.Matter, amt: int) -> int:
  return amt

# Absorb an asteroid with a given kind and size.
func absorb_asteroid(asteroid: Asteroid) -> void:
  var absorbed_matter : MatterCollection =  absorption_limiter(asteroid.matter_collection)

  Global.collection.add_collection(absorbed_matter)

# Override this in sub-classes if overriding limit_one() isn't enough.
func absorption_limiter(to_absorb: MatterCollection) -> MatterCollection:
  var absorbed : MatterCollection = MatterCollection.new()

  to_absorb.each(
    func (mat: MatterCollection.Matter, amt: int): absorbed.set_amount(mat, limit_one(mat, amt))
  )

  return absorbed
