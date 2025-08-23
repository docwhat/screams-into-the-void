
class_name Player extends CharacterBody2D

var move_speed : float = 10000.0


func _ready() -> void:
  position.x = 200 # FIXME
  position.y = 200 # FIXME
  # print_rich(    "Starting Position: %s" % position)
#   # Put the character at the center of the screen
#   position = get_viewport().get_size() / 2

func _process(delta: float) -> void:
  var direction : Vector2 = Vector2(
    Input.get_action_strength("right") - Input.get_action_strength("left"),
    Input.get_action_strength("backwards") - Input.get_action_strength("forward"),
  ).normalized()

  velocity = direction * move_speed

  #if direction:
    #print_rich("Input Vector: %s  Speed: %s" % [direction, move_speed])
    #print_rich("New Velocity: %s" % velocity)
    #print_rich("Current Position:  %s" % position)

func _physics_process(delta: float) -> void:
  move_and_slide()

# func _physics_process(delta: float) -> void:
#   if Input.is_action_pressed("forward"):
#     var change = speed * delta
#     print_rich("Moving up by %s" % change)
#     print_rich("Old position: %s" % position)
#     position.y -= change
#     print_rich("New position: %s" % position)

#func shift_origin() -> void:
  ## Shift everything by the offset of the camera's position
#
  #global_transform.origin -= amera.global_transform.origin
  #$World.transform.origin -= $SleakShip.transform.origin
#
  #$SleakShip.transform.origin = Vector3.ZERO
#
  #print("World shifted to " + str(global_transform.origin))
#
#func _physics_process(_delta: float) -> void:
  ## Set the camera to check to be the current camera
  #camera = get_viewport().get_camera()
#
  ## Check distance of world from camera and shift if greater than threshold
  #if(camera.global_transform.origin.length() > threshold && camera != null):
    #shift_origin()
