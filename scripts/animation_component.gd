class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D
@export var hitbox: CollisionShape2D

@export_subgroup("Settings")
@export var roll_speed = 10
@export var mini_size = Vector2(0.3,0.3)
@export var monster_Size = Vector2(1.05,1.05)
@export var monster_standup_Size = Vector2(1.4,1.4)

var crosshairComponentScene = preload("res://components/crosshair_component.tscn")
var crosshairs:Array[CrosshairComponent]

func _ready():
	sprite.play("pumpIdle")

func handle_evolve(isEvolved: bool):
	if isEvolved:
		hitbox.scale = monster_Size
		#sprite.apply_scale(Vector2(0.25,0.25))
		sprite.play("pumpMonsterIdle")
	else:
		hitbox.scale = mini_size
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
	
func handle_grab_move_animation(direction: float, velocity:float):
	handle_horizontal_flip(direction)
	if velocity > 0:
		sprite.play("pumpMonGrabWalk")
		
func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
	var absScale  = abs(sprite.scale.x)
	#sprite.flip_h = false if move_direction > 0 else true
	sprite.scale.x = absScale if move_direction > 0 else -absScale
	
func handle_grab(holding_prey: bool):
	if !holding_prey:
		hitbox.scale = monster_standup_Size
		sprite.play("pumpMonGrab")
		
		#sprite.apply_scale(Vector2(0.833333,0.833333))
	else:
		sprite.play("pumpMonsterIdle")
		hitbox.scale = monster_Size
		#sprite.apply_scale(Vector2(1.2,1.2))
		
func handle_kill():
	sprite.play("pumpMonKill")
	await get_tree().create_timer(1).timeout
	hitbox.scale = monster_Size
	sprite.play("pumpMonsterIdle")

func handle_infect():
	sprite.play("pumpMonInfect")
	await get_tree().create_timer(0.75).timeout
	hitbox.scale = monster_Size
	sprite.play("pumpMonsterIdle")

func add_crosshair(UID:int):
	var crosshair:CrosshairComponent = crosshairComponentScene.instantiate() as CrosshairComponent
	self.get_parent().add_child(crosshair)
	crosshair.setUID(UID)
	crosshairs.append(crosshair)

func remove_crosshair(UID:int):
	for i in crosshairs.size():
		if crosshairs.get(i).getUID() == UID:
			self.get_parent().remove_child(crosshairs.get(i))
			crosshairs.remove_at(i)
			return
