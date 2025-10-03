class_name StarterAbsorber extends Absorber

static func get_name() -> String:
  return "Barely functioning processor"

static func get_description() -> String:
  return "The best you're able to do, given your condition."

# Only absorbs 0 or 1, based on a coin flip.
static func limit_one(_mat: Matter, _amt: int) -> int:
  return 1
  #if amt <= 0:
	#return 0
#
  #return Global.rng.randi_range(0,1)
