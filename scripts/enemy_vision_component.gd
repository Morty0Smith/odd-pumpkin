class_name EnemyVisionComponent
extends Node

var playerMemoryTimer:float
@export var stepRaycast:RayCast2D
@export var visionRaycast:RayCast2D
@export var characterBody:CharacterBody2D

func canSeePlayer(playerMemoryDuration:float, player:CharacterBody2D, viewcone:Area2D, deltaT:float) ->bool:
	var playerClass = player as Player
	playerMemoryTimer -= deltaT
	var playerIsMoving:bool = !(player.velocity == Vector2(0,0))
	var playerViewObstructed:bool = !castToObj(player)
	var playerVisible:bool = !playerViewObstructed and player in viewcone.get_overlapping_bodies()
	var playerInMemory:bool = playerMemoryTimer > 0
	if playerVisible and (playerInMemory or playerIsMoving or playerClass.isEvolved):
		playerMemoryTimer = playerMemoryDuration
	return playerMemoryTimer > 0

func checkForSteps() ->bool:
	stepRaycast.force_raycast_update()
	if stepRaycast.get_collider() != null:
		return true
	return false

func castToObj(obj:CharacterBody2D) ->bool:
	var enemySprite:Node2D = visionRaycast.get_parent() as Node2D
	visionRaycast.scale = Vector2( 1/enemySprite.scale.x, 1/enemySprite.scale.y) # To fix weird scaling issues with the raycast
	var directionToObj:Vector2 = visionRaycast.get_global_transform().origin.direction_to(obj.global_position)
	var distanceToObj:float = visionRaycast.get_global_transform().origin.distance_to(obj.global_position)
	visionRaycast.target_position = directionToObj * distanceToObj
	visionRaycast.add_exception(characterBody)
	visionRaycast.force_raycast_update()
	return visionRaycast.is_colliding() and visionRaycast.get_collider() == obj

func forgetPlayer():
	playerMemoryTimer = 0
