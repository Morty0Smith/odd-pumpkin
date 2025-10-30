class_name Player
extends CharacterBody2D

@export_subgroup("Nodes")
@export var input_component: InputComponent
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export_subgroup("Settings")
@export var isEvolved = false
var holdingPrey = false

func _physics_process(delta: float) -> void:
	if input_component.get_evolved() and !holdingPrey:
		isEvolved = !isEvolved
		animation_component.handle_evolve(isEvolved)
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal, isEvolved)
	if !isEvolved:
		movement_component.handle_jump(self, input_component.get_jump_input())
		animation_component.handle_roll_animation(input_component.input_horizontal)
	else:
		animation_component.handle_move_animation(input_component.input_horizontal)
		if input_component.get_grab():
			animation_component.handle_grab(holdingPrey)
			holdingPrey = !holdingPrey
	move_and_slide()
