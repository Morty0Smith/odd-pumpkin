class_name Enemy
extends Node2D

@export_subgroup("Components")
@export var gravity_component: GravityComponent
@export var enemy_vision_component: EnemyVisionComponent
@export var movement:EnemyMovement
@export var unique_id_component:UniqueIdComponent

@export_subgroup("Nodes")
@export var characterBody:CharacterBody2D
@export var viewcone:Area2D
@export var blowUpArea:Area2D
@export var enemyTimer:Timer
@export var damageTimer:Timer
@export var roamEdgeLeft:Node2D
@export var roamEdgeRight:Node2D
@export var visual_viewcone:Node2D

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

func _ready() -> void:
	player = get_node("/root/SceneRoot/Player")
	ui_manager = get_node("/root/SceneRoot/UI/UI_Manager") as UIManager
	playerClass = player as Player
	playerClass.triggerInfection.connect(_on_player_trigger_infection)
	
func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(characterBody,delta)
	if isDead or isDazed:
		visual_viewcone.visible = false
		enemy_vision_component.forgetPlayer()
		ui_manager.resetSeenLevel(unique_id_component.getUID())
		return
	visual_viewcone.visible = true
	var canSeePlayer:bool = enemy_vision_component.canSeePlayer(playerMemoryDuration, player,viewcone,delta)
	if (damageTimer.time_left == 0):
		playerClass.animation_component.remove_crosshair(unique_id_component.getUID())
	if !canSeePlayer:
		ui_manager.resetSeenLevel(unique_id_component.getUID())
	if isGrabbed:
		damageTimer.stop()
		characterBody.global_position.x = grabCollider.global_position.x
		return
	if canSeePlayer:
		ui_manager.setSeenLevel(2,unique_id_component.getUID())
		var hasReachedPlayer:bool = movement.goToPos(player.global_position,playerChaseDistance,jumpVelocity)
		if !hasReachedPlayer:
			damageTimer.stop()
		if hasReachedPlayer and damageTimer.time_left == 0:
			damageTimer.start(0.5)
			playerClass.animation_component.add_crosshair(unique_id_component.getUID())
	if !canSeePlayer:
		damageTimer.stop()
		movement.moveNormalCycle(roamEdgeLeft,roamEdgeRight,jumpVelocity)
	
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
	var objectsInRadius = blowUpArea.get_overlapping_bodies()
	for object in objectsInRadius:
		var objectParent = object.get_parent()
		if objectParent != null and objectParent is Enemy:
			(objectParent as Enemy).kill()

func _on_enemy_timer_timeout() -> void:
	if isDazed: #After two seconds, the enemy get up from dazing
		isDazed = false
		enemyTimer.start(58)
	else: #After one minute, the health regenerates
		isInfected = false


func _on_damage_timer_timeout() -> void:
	playerClass.health_component.add_health(-1,ui_manager)
	playerClass.animation_component.add_crosshair(unique_id_component.getUID())
	

func _on_player_trigger_infection() -> void:
	if isInfected:
		blowUp()
