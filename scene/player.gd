class_name Player
extends CharacterBody2D

@export_subgroup("Nodes")
@export var input_component: InputComponent
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var attack_component: AttackComponent
@export var grabHitbox:Area2D
@export_subgroup("Settings")
@export var isEvolved = false

signal triggerInfection
var testCounter:int = 0

func _physics_process(delta: float) -> void:
	testCounter += 1
	if testCounter == 100:
		triggerInfection.emit()
	if input_component.get_evolved() and !attack_component.getHasGrabbed():
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
			animation_component.handle_grab(attack_component.getHasGrabbed())
			attack_component.handle_grab()
	move_and_slide()
