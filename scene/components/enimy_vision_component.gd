class_name EnimyVisionComponent
extends Node

var playerMemoryTimer:float

func canSeePlayer(playerMemoryDuration:float, player:CharacterBody2D, viewcone:Area2D, deltaT:float) ->bool:
	playerMemoryTimer -= deltaT
	var playerIsMoving:bool = !(player.velocity == Vector2(0,0))
	var canSeePlayer:bool = playerIsMoving and player in viewcone.get_overlapping_bodies()
	if canSeePlayer:
		playerMemoryTimer = playerMemoryDuration
	var playerInMemory:bool = playerMemoryTimer > 0
	return canSeePlayer or playerInMemory
