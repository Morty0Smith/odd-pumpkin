extends Node2D

@export var movement:EnimyMovement
@export var viewcone:Area2D
@export var playerCollision:CollisionObject2D
@export var characterBody:CharacterBody2D
@export var gravity_component: GravityComponent

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(characterBody,delta)
	var canSeePlayer:bool = playerCollision in viewcone.get_overlapping_bodies()
	if (canSeePlayer):
		movement.goToPos(playerCollision.position)
	else:
		movement.moveNormalCycle()
	
