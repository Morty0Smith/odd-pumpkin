class_name MovementComponent
extends Node

@export_subgroup("Settings")
@export var roll_speed: float = 200
@export var walk_speed: float = 75
@export var jump_velocity: float = -200.0

var is_jumping: bool = false

func handle_horizontal_movement(body: CharacterBody2D, direction: float, evolved: bool) -> void:
	if evolved:
		body.velocity.x = direction * walk_speed
	else:
		body.velocity.x = direction * roll_speed

func handle_jump(body: CharacterBody2D, want_to_jump: bool) -> void:
	if want_to_jump and body.is_on_floor():
		body.velocity.y = jump_velocity

	is_jumping = body.velocity.y < 0 and not body.is_on_floor()
