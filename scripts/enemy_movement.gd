class_name EnemyMovement
extends Node

@export var characterBody:CharacterBody2D
@export var enemySprite:Sprite2D
@export var moveSpeed:float = 20
@export var enemy_vision_component:EnemyVisionComponent

var moveToLeft:bool = false
var normalCycleTurnMargin:float = 5

func moveNormalCycle(roamEdgeLeft:Node2D,roamEdgeRight:Node2D, jumpVelocity:float):
	var targetPos:Vector2 = roamEdgeLeft.global_position if (moveToLeft) else roamEdgeRight.global_position
	if(abs(targetPos.x - characterBody.global_position.x) < normalCycleTurnMargin):
		moveToLeft = !moveToLeft
	goToPos(targetPos, normalCycleTurnMargin - 1, jumpVelocity)

func goToPos(targetPos:Vector2, stopMargin:float, jumpVelocity:float):
	if(abs(targetPos.x - characterBody.global_position.x) < stopMargin):
		return
	if (characterBody.global_position.x < targetPos.x):
		characterBody.velocity.x = moveSpeed
		enemySprite.scale.x = 1
	if (characterBody.global_position.x > targetPos.x):
		characterBody.velocity.x = -moveSpeed
		enemySprite.scale.x = -1
	characterBody.move_and_slide()
	if enemy_vision_component.checkForSteps():
		jump(jumpVelocity)

func jump(jumpVelocity:float):
	if (characterBody.is_on_floor()):
		characterBody.velocity.y = -jumpVelocity
		characterBody.move_and_slide()
