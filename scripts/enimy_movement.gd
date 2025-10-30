class_name EnimyMovement
extends Node

@export var characterBody:CharacterBody2D
@export var enimySprite:Sprite2D
@export var moveSpeed:float = 20

var moveToLeft:bool = false
var normalCycleTurnMargin:float = 5

func moveNormalCycle(roamEdgeLeft:Node2D,roamEdgeRight:Node2D):
	var targetPos:Vector2 = roamEdgeLeft.global_position if (moveToLeft) else roamEdgeRight.global_position
	if(abs(targetPos.x - characterBody.global_position.x) < normalCycleTurnMargin):
		moveToLeft = !moveToLeft
	goToPos(targetPos, normalCycleTurnMargin - 1)

func goToPos(targetPos:Vector2, stopMargin:float):
	if(abs(targetPos.x - characterBody.global_position.x) < stopMargin):
		return
	if (characterBody.global_position.x < targetPos.x):
		characterBody.velocity.x = moveSpeed
		enimySprite.scale.x = 1
	if (characterBody.global_position.x > targetPos.x):
		characterBody.velocity.x = -moveSpeed
		enimySprite.scale.x = -1
	characterBody.move_and_slide()
