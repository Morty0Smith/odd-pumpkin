class_name EnemyMovement
extends Node

@export var characterBody:CharacterBody2D
@export var enemySprite:AnimatedSprite2D
@export var moveSpeed:float = 20
@export var fallDistanceAfterDead = 11
@export var enemy_vision_component:EnemyVisionComponent

var moveToLeft:bool = false
var normalCycleTurnMargin:float = 5


func moveNormalCycle(roamEdgeLeft:Node2D,roamEdgeRight:Node2D, jumpVelocity:float):
	var targetPos:Vector2 = roamEdgeLeft.global_position if (moveToLeft) else roamEdgeRight.global_position
	if(abs(targetPos.x - characterBody.global_position.x) < normalCycleTurnMargin):
		moveToLeft = !moveToLeft
	goToPos(targetPos, normalCycleTurnMargin - 1, jumpVelocity)

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
