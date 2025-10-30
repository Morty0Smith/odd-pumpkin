extends Node2D

@export var movement:EnemyMovement
@export var viewcone:Area2D
@export var characterBody:CharacterBody2D
@export var gravity_component: GravityComponent
@export var enemy_vision_component: EnemyVisionComponent
@export var playerMemoryDuration:float = 3
@export var roamEdgeLeft:Node2D
@export var roamEdgeRight:Node2D
@export var playerChaseDistance:float = 20
@export var jumpVelocity:float = 200

var player:CharacterBody2D
var playerInMemoryTime

func _ready() -> void:
	player = get_node("/root/SceneRoot/Player")
	
func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(characterBody,delta)
	var canSeePlayer:bool = enemy_vision_component.canSeePlayer(playerMemoryDuration, player,viewcone,delta)
	if (canSeePlayer):
		movement.goToPos(player.global_position,playerChaseDistance,jumpVelocity)
	else:
		movement.moveNormalCycle(roamEdgeLeft,roamEdgeRight,jumpVelocity)
	
