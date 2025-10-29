class_name EnimyMovement
extends Node

@export var characterBody:CharacterBody2D
@export var roamEdgeLeft:Node2D
@export var roamEdgeRight:Node2D
@export var moveSpeed:float = 20

var moveToLeft:bool = false

func moveNormalCycle():
	var targetPos:Vector2 = roamEdgeLeft.position if (moveToLeft) else roamEdgeRight.position
	goToPos(targetPos)
	if (!moveToLeft and characterBody.position.x > targetPos.x):
		moveToLeft = true
	if (moveToLeft and characterBody.position.x < targetPos.x):
		moveToLeft = false

func goToPos(targetPos:Vector2):
	if (characterBody.position.x < targetPos.x and characterBody.velocity.x != moveSpeed):
		characterBody.velocity.x = moveSpeed
	if (characterBody.position.x > targetPos.x and characterBody.velocity.x != -moveSpeed):
		characterBody.velocity.x = -moveSpeed
	characterBody.move_and_slide()
