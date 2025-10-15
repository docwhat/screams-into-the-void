class_name Player
extends Area2D

# The player's ability to absorb things.
var absorber: Absorber


func _ready() -> void:
	absorber = StarterAbsorber.new()

	get_viewport().size_changed.connect(_on_resized)
	recenter_player.call_deferred()

	Events.asteroid_hit.connect(asteroid_hit)


# Used when an asteroid hits the player.
func asteroid_hit(asteroid: Asteroid) -> void:
	absorber.absorb_asteroid(asteroid)


func recenter_player():
	var screen_size = get_viewport_rect().size
	var new_position = Vector2(
		screen_size.x / 2.0,
		screen_size.y - Global.player_size.y / 1.5,
	)

	position = new_position
	Global.player_position = new_position


func _on_resized():
	recenter_player.call_deferred()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("be_absorbed"):
		body.be_absorbed()
