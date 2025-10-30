class_name EnemyVisionComponent
extends Node

var playerMemoryTimer:float
@export var stepRaycast:RayCast2D

func canSeePlayer(playerMemoryDuration:float, player:CharacterBody2D, viewcone:Area2D, deltaT:float) ->bool:
	var playerClass = player as Player
	playerMemoryTimer -= deltaT
	var playerIsMoving:bool = !(player.velocity == Vector2(0,0))
	var canSeePlayer:bool = (playerIsMoving or playerClass.isEvolved) and player in viewcone.get_overlapping_bodies()
	if canSeePlayer:
		playerMemoryTimer = playerMemoryDuration
	var playerInMemory:bool = playerMemoryTimer > 0
	return canSeePlayer or playerInMemory

func checkForSteps() ->bool:
	stepRaycast.force_raycast_update()
	if stepRaycast.get_collider() is TileMapLayer:
		return true
	return false
