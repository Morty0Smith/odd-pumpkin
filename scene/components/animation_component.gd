class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: Sprite2D


func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return

	sprite.flip_h = false if move_direction > 0 else true

func handle_evolve(isEvolved: bool):
	if isEvolved:
		sprite.apply_scale(Vector2(1,3))
	else:
		sprite.apply_scale(Vector2(1,0.333333333))
