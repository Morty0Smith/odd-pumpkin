class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: Sprite2D
@export var hitbox: CollisionShape2D

@export_subgroup("Settings")
@export var roll_speed = 10

func handle_evolve(isEvolved: bool):
	if isEvolved:
		hitbox.apply_scale(Vector2(1,3))
	else:
		hitbox.apply_scale(Vector2(1,0.333333333))

func handle_roll_animation(direction: float):
	handle_horizontal_flip(direction)
	if direction != 0:
		sprite.rotation_degrees += direction*roll_speed
	else:
		#sprite.rotation_degrees = 0 #hide animationd
		pass
		
func handle_move_animation(direction: float):
	sprite.rotation_degrees = 0 #walk cycle hier
		
func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return

	sprite.flip_h = false if move_direction > 0 else true
