extends Node2D

@export var movement:EnimyMovement
@export var viewcone:Area2D
@export var playerCollision:CollisionObject2D

func _physics_process(delta: float) -> void:
	movement.moveNormalCycle()
	var canSeePlayer:bool = playerCollision in viewcone.get_overlapping_bodies()
	if (canSeePlayer):
		movement.goToPos(playerCollision.position)
