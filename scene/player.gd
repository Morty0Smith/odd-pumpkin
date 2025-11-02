class_name Player
extends CharacterBody2D

@onready var audio_player_component: AudioPlayerComponent = $AudioPlayerComponent

@export_subgroup("Nodes")
@export var input_component: InputComponent
@export var gravity_component: GravityComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var attack_component: AttackComponent
@export var uid_component: UniqueIdComponent
@export var health_component:HealthComponent
@export var grabHitbox:Area2D
@export_subgroup("Settings")
@export var isEvolved = false

signal triggerInfection
var ui_manager:UIManager

func _ready() -> void:
	ui_manager = get_node("/root/SceneRoot/UI/UI_Manager") as UIManager

func _physics_process(delta: float) -> void:
	if input_component.get_evolved() and !attack_component.getHasGrabbed():
		isEvolved = !isEvolved
		animation_component.handle_evolve(isEvolved)
	gravity_component.handle_gravity(self, delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal, isEvolved)
# ---------- UNEVOLVED ----------
	if !isEvolved:
		movement_component.handle_jump(self, input_component.get_jump_input())
		animation_component.handle_roll_animation(input_component.input_horizontal)
# ---------- attack ----------
		if input_component.get_infect():
			triggerInfection.emit()
# ---------- EVOLVED ----------
	else:
		if !attack_component.getHasGrabbed():
			animation_component.handle_move_animation(input_component.input_horizontal)
		else:
			animation_component.handle_grab_move_animation(input_component.input_horizontal, self.velocity.x)
# ---------- attacks ----------
		if input_component.get_kill() and attack_component.getHasGrabbed():
			audio_player_component.playSoundEffectWithName("kill")
			animation_component.handle_kill()
			attack_component.handle_kill()
			
		if input_component.get_infect():
			if attack_component.getHasGrabbed():
				audio_player_component.playSoundEffectWithName("infect")
				animation_component.handle_infect()
				attack_component.handle_infect()
			else:
				triggerInfection.emit()
			
		if input_component.get_grab():
			animation_component.handle_grab(attack_component.getHasGrabbed())
			attack_component.handle_grab()
		
	move_and_slide()
# ---------- SeenLevel ----------
	if ui_manager.getSeenLevel() >= 2:
		return
	if velocity.x == 0 and velocity.y == 0 and !isEvolved:
		ui_manager.setSeenLevel(0,uid_component.getUID())
	else:
		ui_manager.setSeenLevel(1,uid_component.getUID())
