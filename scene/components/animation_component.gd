class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D
@export var hitbox: CollisionShape2D

@export_subgroup("Settings")
@export var roll_speed = 10

func _ready():
	sprite.play("pumpIdle")

func handle_evolve(isEvolved: bool):
	if isEvolved:
		hitbox.apply_scale(Vector2(4,4))
		#sprite.apply_scale(Vector2(0.25,0.25))
		sprite.play("pumpMonsterIdle")
	else:
		hitbox.apply_scale(Vector2(0.25,0.25))
		#sprite.apply_scale(Vector2(4,4))
		sprite.play("pumpIdle")

func handle_roll_animation(direction: float):
	handle_horizontal_flip(direction)
	if direction != 0:
		sprite.rotation_degrees += direction*roll_speed
	else:
		#sprite.rotation_degrees = 0 #hide animationd
		pass
		
func handle_move_animation(direction: float):
	handle_horizontal_flip(direction)
	sprite.rotation_degrees = 0 #walk cycle hier
		
func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
	var absScale  = abs(sprite.scale.x)
	#sprite.flip_h = false if move_direction > 0 else true
	sprite.scale.x = absScale if move_direction > 0 else -absScale
	
func handle_grab(holding_prey: bool):
	if !holding_prey:
		sprite.play("pumpMonGrab")
		hitbox.apply_scale(Vector2(1.2,1.2))
		#sprite.apply_scale(Vector2(0.833333,0.833333))
	else:
		sprite.play("pumpMonsterIdle")
		hitbox.apply_scale(Vector2(0.833333,0.833333))
		#sprite.apply_scale(Vector2(1.2,1.2))
