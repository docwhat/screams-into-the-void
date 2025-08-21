
extends CharacterBody2D

const speed = 100

func _ready() -> void:
	# Put the character at the center of the screen
	position = get_viewport().get_size() / 2

func _physics_process(_delta: float) -> void:
	velocity = Vector2(0, -1) * speed
	move_and_slide()

func _draw() -> void:
	draw_circle(position, 3.0, Color.GREEN_YELLOW)
