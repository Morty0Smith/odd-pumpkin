class_name EnemyVisionComponent
extends Node

var playerMemoryTimer:float
@export var stepRaycast:RayCast2D
@export var visionRaycast:RayCast2D
@export var enemySprite:AnimatedSprite2D

func canSeePlayer(playerMemoryDuration:float, player:CharacterBody2D, viewcone:Area2D, deltaT:float) ->bool:
	var playerClass = player as Player
	playerMemoryTimer -= deltaT
	var playerIsMoving:bool = !(player.velocity == Vector2(0,0))
	var spriteFlipped:bool = enemySprite.scale.x < 0
	var playerViewObstructed:bool = !castToPlayer(player, spriteFlipped)
	var playerVisible:bool = !playerViewObstructed and player in viewcone.get_overlapping_bodies()
	var playerInMemory:bool = playerMemoryTimer > 0
	if playerVisible and (playerInMemory or (playerIsMoving or playerClass.isEvolved)):
		playerMemoryTimer = playerMemoryDuration
	return playerMemoryTimer > 0

func checkForSteps() ->bool:
	stepRaycast.force_raycast_update()
	if stepRaycast.get_collider() != null:
		return true
	return false

func castToPlayer(player:CharacterBody2D, spriteFlipped:bool) ->bool:
	var directionToPlayer:Vector2 = visionRaycast.get_global_transform().origin.direction_to(player.global_position)
	var distanceToPlayer:float = visionRaycast.get_global_transform().origin.distance_to(player.global_position)
	visionRaycast.target_position = directionToPlayer * distanceToPlayer
	if (spriteFlipped):
		visionRaycast.target_position.x *= -1
	visionRaycast.force_raycast_update()
	return visionRaycast.is_colliding() and visionRaycast.get_collider() == player

func forgetPlayer():
	playerMemoryTimer = 0
