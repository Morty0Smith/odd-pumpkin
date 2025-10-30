extends Node2D

@export var movement:EnimyMovement
@export var viewcone:Area2D
@export var characterBody:CharacterBody2D
@export var gravity_component: GravityComponent
@export var enimy_vision_component: EnimyVisionComponent
@export var playerMemoryDuration:float = 3
@export var roamEdgeLeft:Node2D
@export var roamEdgeRight:Node2D

var player:CharacterBody2D
var playerInMemoryTime

func _ready() -> void:
	player = get_node("/root/SceneRoot/Player")
	
func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(characterBody,delta)
	var canSeePlayer:bool = enimy_vision_component.canSeePlayer(playerMemoryDuration, player,viewcone,delta)
	if (canSeePlayer):
		movement.goToPos(player.global_position)
	else:
		movement.moveNormalCycle(roamEdgeLeft,roamEdgeRight)
	
