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
var playerInMemoryTime
var grabCollider:CollisionShape2D
var isDazed:bool = false
var isDead:bool = false
var isInfected:bool = false
var isGrabbed:bool = false

func _ready() -> void:
	player = get_node("/root/SceneRoot/Player")
	ui_manager = get_node("/root/SceneRoot/UI/UI_Manager") as UIManager
	(player as Player).triggerInfection.connect(_on_player_trigger_infection)
	
func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(characterBody,delta)
	var canSeePlayer:bool = enemy_vision_component.canSeePlayer(playerMemoryDuration, player,viewcone,delta)
	if isGrabbed and !isDazed and !isDead:
		damageTimer.stop()
		characterBody.global_position.x = grabCollider.global_position.x
	if canSeePlayer and !isDead and !isDazed and !isGrabbed:
		ui_manager.setSeenLevel(2,unique_id_component.getUID())
		var hasReachedPlayer:bool = movement.goToPos(player.global_position,playerChaseDistance,jumpVelocity)
		if !hasReachedPlayer:
			damageTimer.stop()
		if hasReachedPlayer and damageTimer.time_left == 0:
			damageTimer.start(0.5)
	if !canSeePlayer and !isDead and !isDazed and !isGrabbed:
		damageTimer.stop()
		movement.moveNormalCycle(roamEdgeLeft,roamEdgeRight,jumpVelocity)
	if !canSeePlayer or isDead or isDazed:
		ui_manager.resetSeenLevel(unique_id_component.getUID())
	if isDead or isDazed:
		visual_viewcone.visible = false
	else:
		visual_viewcone.visible = true
	
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
	(player as Player).health_component.add_health(-1,ui_manager)


func _on_player_trigger_infection() -> void:
	if isInfected:
		blowUp()
