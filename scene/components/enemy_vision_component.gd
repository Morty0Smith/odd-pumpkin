class_name EnemyVisionComponent
extends Node

var playerMemoryTimer:float
@export var stepRaycast:RayCast2D
@export var visionRaycast:RayCast2D
@export var enemySprite:Sprite2D

func canSeePlayer(playerMemoryDuration:float, player:CharacterBody2D, viewcone:Area2D, deltaT:float) ->bool:
	var playerClass = player as Player
	playerMemoryTimer -= deltaT
	var playerIsMoving:bool = !(player.velocity == Vector2(0,0))
	var spriteFlipped:bool = enemySprite.scale.x == -1
	var playerViewObstructed:bool = !castToPlayer(player, spriteFlipped)
	var playerVisible:bool = !playerViewObstructed and (playerIsMoving or playerClass.isEvolved) and player in viewcone.get_overlapping_bodies()
	if canSeePlayer:
		playerMemoryTimer = playerMemoryDuration
	var playerInMemory:bool = playerMemoryTimer > 0
	return playerVisible or playerInMemory

func checkForSteps() ->bool:
	stepRaycast.force_raycast_update()
	if stepRaycast.get_collider() is TileMapLayer:
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
