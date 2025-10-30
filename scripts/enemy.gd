class_name Enemy
extends Node2D

@export var movement:EnemyMovement
@export var viewcone:Area2D
@export var characterBody:CharacterBody2D
@export var blowUpArea:Area2D
@export var enemyTimer:Timer
@export var gravity_component: GravityComponent
@export var enemy_vision_component: EnemyVisionComponent
@export var playerMemoryDuration:float = 3
@export var roamEdgeLeft:Node2D
@export var roamEdgeRight:Node2D
@export var playerChaseDistance:float = 20
@export var jumpVelocity:float = 200

var player:CharacterBody2D
var playerInMemoryTime
var playerGrabPosRelative:Vector2
var isDazed = false
var isDead = false
var isInfected = false
var isGrabbed = false

func _ready() -> void:
	player = get_node("/root/SceneRoot/Player")
	
func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(characterBody,delta)
	var canSeePlayer:bool = enemy_vision_component.canSeePlayer(playerMemoryDuration, player,viewcone,delta)
	if isGrabbed and !isDazed and !isDead:
		self.global_position = player.global_position + playerGrabPosRelative
	if canSeePlayer and !isDead and !isDazed and !isGrabbed:
		movement.goToPos(player.global_position,playerChaseDistance,jumpVelocity)
	if !canSeePlayer and !isDead and !isDazed and !isGrabbed:
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
	playerGrabPosRelative = player.global_position - self.global_position

func blowUp():
	var objectsInRadius = blowUpArea.get_overlapping_bodies()
	for object in objectsInRadius:
		var objectParent = object.get_parent()
		if objectParent != null and objectParent is Enemy:
			print(objectParent)
			(objectParent as Enemy).kill()

func _on_enemy_timer_timeout() -> void:
	if isDazed: #After two seconds, the enemy get up from dazing
		isDazed = false
		enemyTimer.start(58)
	else: #After one minute, the health regenerates
		isInfected = false
