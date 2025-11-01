class_name EnemyMovement
extends Node

@export var characterBody:CharacterBody2D
@export var enemySprite:AnimatedSprite2D
@export var moveSpeed:float = 20
@export var fallDistanceAfterDead = 15
@export var enemy_vision_component:EnemyVisionComponent
@export var roam_wait_timer:Timer

var moveToLeft:bool = false
var normalCycleTurnMargin:float = 5
var randomCycleTurnMarginOffset:float = 0

func _ready() -> void:
	randomCycleTurnMarginOffset = randi_range(0,30)

func moveNormalCycle(roamEdgeLeft:RoamEdge,roamEdgeRight:RoamEdge, jumpVelocity:float):
	var currentRoamEdge:RoamEdge = roamEdgeLeft if (moveToLeft) else roamEdgeRight
	var targetPos:Vector2 = currentRoamEdge.global_position
	if(abs(targetPos.x - characterBody.global_position.x) < normalCycleTurnMargin + randomCycleTurnMarginOffset):
		if roam_wait_timer.time_left == 0:
			roam_wait_timer.start(currentRoamEdge.getWaitTime())
	goToPos(targetPos, normalCycleTurnMargin - 1 + randomCycleTurnMarginOffset, jumpVelocity)

func goToPos(targetPos:Vector2, stopMargin:float, jumpVelocity:float) ->bool: # Returns true, if it has reached it's destination
	if(abs(targetPos.x - characterBody.global_position.x) < stopMargin):
		characterBody.velocity.x = 0
		return true
	if (characterBody.global_position.x < targetPos.x):
		characterBody.velocity.x = moveSpeed
		enemySprite.scale.x = abs(enemySprite.scale.x)
	if (characterBody.global_position.x > targetPos.x):
		characterBody.velocity.x = -moveSpeed
		enemySprite.scale.x = -abs(enemySprite.scale.x)
	characterBody.move_and_slide()
	if enemy_vision_component.checkForSteps():
		jump(jumpVelocity)
	return false

func jump(jumpVelocity:float):
	if (characterBody.is_on_floor()):
		characterBody.velocity.y = -jumpVelocity
		characterBody.move_and_slide()

func stopMoving():
	if (characterBody.rotation_degrees != 90):
		characterBody.velocity.x = 0
		characterBody.position.y += fallDistanceAfterDead
		characterBody.rotation_degrees = 90


func _on_roam_wait_timer_timeout() -> void:
	randomCycleTurnMarginOffset = randi_range(0,30)
	moveToLeft = !moveToLeft
