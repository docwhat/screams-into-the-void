class_name Absorber

static func get_name() -> String:
	return "The perfect processor"


static func get_description() -> String:
	return "Processes and absorbs 100% of all resources."


## A non-limiter. Override to behave differently.
static func limit_one(_mat: Matter, amt: int) -> int:
	return amt


## Absorb an asteroid with a given kind and size.
func absorb_asteroid(asteroid: Asteroid) -> void:
	var absorbed_matter: MatterBag = absorption_limiter(asteroid.matter_collection)

	State.matter.add_bag(absorbed_matter)


## Override this in sub-classes if overriding limit_one() isn't enough.
func absorption_limiter(to_absorb: MatterBag) -> MatterBag:
	var absorbed: MatterBag = MatterBag.new()

	for matter: Matter in to_absorb.keys():
		absorbed.set_by_matter(matter, limit_one(matter, to_absorb.get_by_matter(matter)))

	return absorbed
