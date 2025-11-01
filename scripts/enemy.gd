class_name Enemy
extends Node2D

@onready var audio_player_component: AudioPlayerComponent = $AudioPlayerComponent

@export_subgroup("Components")
@export var gravity_component: GravityComponent
@export var enemy_vision_component: EnemyVisionComponent
@export var movement:EnemyMovement
@export var unique_id_component:UniqueIdComponent
@export var enemy_animation_component:EnemyAnimationComponent

@export_subgroup("Nodes")
@export var characterBody:CharacterBody2D
@export var viewcone:Area2D
@export var blowUpArea:Area2D
@export var enemyTimer:Timer
@export var damageTimer:Timer
@export var roamEdgeLeft:RoamEdge
@export var roamEdgeRight:RoamEdge
@export var visual_viewcone:Node2D
@export var questionMark:Sprite2D
@export var investigate_wait_timer:Timer

@export_subgroup("Values")
@export var playerMemoryDuration:float = 3
@export var playerChaseDistance:float = 20
@export var jumpVelocity:float = 200
@export var damageIntervall = 0.5

var ui_manager:UIManager
var player:CharacterBody2D
var playerClass:Player
var playerInMemoryTime
var grabCollider:CollisionShape2D
var isDazed:bool = false
var isDead:bool = false
var isInfected:bool = false
var isGrabbed:bool = false
var isAttacking:bool = false
var isInvestigating:bool = false
var investigationPos:Vector2
var investigatingWaitTime:float = 1

func _ready() -> void:
	player = get_node("/root/SceneRoot/Player")
	ui_manager = get_node("/root/SceneRoot/UI/UI_Manager") as UIManager
	playerClass = player as Player
	playerClass.triggerInfection.connect(_on_player_trigger_infection)
	
func _physics_process(delta: float) -> void:
	questionMark.visible = isInvestigating
	gravity_component.handle_gravity(characterBody,delta)
	enemy_animation_component.handleAnimation(isAttacking,characterBody.velocity.x)
	if isDead or isDazed:
		damageTimer.stop()
		isInvestigating = false
		visual_viewcone.visible = false
		enemy_vision_component.forgetPlayer()
		ui_manager.resetSeenLevel(unique_id_component.getUID())
		isAttacking = false
		movement.stopMoving()
		return
	visual_viewcone.visible = true
	var canSeePlayer:bool = enemy_vision_component.canSeePlayer(playerMemoryDuration, player,viewcone,delta)
	if (damageTimer.time_left == 0):
		isAttacking = false
		playerClass.animation_component.remove_crosshair(unique_id_component.getUID())
	else:
		isAttacking = true
	if !canSeePlayer:
		ui_manager.resetSeenLevel(unique_id_component.getUID())
	if isGrabbed:
		isAttacking = false
		damageTimer.stop()
		characterBody.global_position.x = grabCollider.global_position.x
		return
	if canSeePlayer:
		isInvestigating = false
		ui_manager.setSeenLevel(2,unique_id_component.getUID())
		var hasReachedPlayer:bool = movement.goToPos(player.global_position,playerChaseDistance,jumpVelocity)
		if !hasReachedPlayer:
			damageTimer.stop()
		if hasReachedPlayer and damageTimer.time_left == 0:
			audio_player_component.playSoundEffectWithName("shot")
			damageTimer.start(0.5)
			playerClass.animation_component.add_crosshair(unique_id_component.getUID())
	if !canSeePlayer:
		damageTimer.stop()
		if !isInvestigating:
			movement.moveNormalCycle(roamEdgeLeft,roamEdgeRight,jumpVelocity)
		else:
			if (movement.goToPos(investigationPos,4,jumpVelocity)) and investigate_wait_timer.time_left == 0:
				investigate_wait_timer.start(investigatingWaitTime)
	
func kill():
	isDead = true
	isGrabbed = false

func infect():
	isDazed = true
	isInfected = true
	isGrabbed = false
	enemyTimer.start(2)

func setGrabbed(grab:bool):
	isGrabbed = grab
	grabCollider = player.get_node("Pumpkin/grabHitbox/grabCollider")

func blowUp():
	enemy_animation_component.isTurnedToDust = true
	var objectsInRadius = blowUpArea.get_overlapping_bodies()
	audio_player_component.playSoundEffectWithName("blow_up")
	for object in objectsInRadius:
		var objectParent = object.get_parent()
		if objectParent != null and objectParent is Enemy:
			(objectParent as Enemy).kill()

func _on_enemy_timer_timeout() -> void:
	if isDazed: #After two seconds, the enemy get up from dazing
		isDazed = false
		movement.startMovingAfterDazed()
		enemyTimer.start(58)
	else: #After one minute, the health regenerates
		isInfected = false


func _on_damage_timer_timeout() -> void:
	playerClass.health_component.add_health(-1,ui_manager)
	playerClass.animation_component.add_crosshair(unique_id_component.getUID())
	audio_player_component.playSoundEffectWithName("shot")
	

func _on_player_trigger_infection() -> void:
	if isInfected:
		blowUp()


func _on_investigate_wait_t_imer_timeout() -> void:
	isInvestigating = false
