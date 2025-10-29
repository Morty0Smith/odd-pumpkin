class_name EnimyMovement
extends Node

@export var characterBody:CharacterBody2D
@export var roamEdgeLeft:Node2D
@export var roamEdgeRight:Node2D
@export var enimySprite:Sprite2D
@export var moveSpeed:float = 20

var moveToLeft:bool = false

func moveNormalCycle():
	var targetPos:Vector2 = roamEdgeLeft.global_position if (moveToLeft) else roamEdgeRight.global_position
	if(abs(targetPos.x - characterBody.global_position.x) < 5):
		moveToLeft = !moveToLeft
	goToPos(targetPos)

func goToPos(targetPos:Vector2):
	if (characterBody.global_position.x < targetPos.x):
		characterBody.velocity.x = moveSpeed
		enimySprite.scale.x = -1
	if (characterBody.global_position.x > targetPos.x):
		characterBody.velocity.x = -moveSpeed
		enimySprite.scale.x = 1
	characterBody.move_and_slide()
