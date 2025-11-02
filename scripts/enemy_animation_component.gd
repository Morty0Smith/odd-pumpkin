class_name  EnemyAnimationComponent
extends Node

@onready var explosion: AnimatedSprite2D = $"../CharacterBody/explosion"

@export var enemySprite:AnimatedSprite2D

var guyIndex:int = 2

func _ready() -> void:
	explosion.visible = false

func handleAnimation(isAttacking:bool, xVelocity:float):
	if xVelocity == 0 and isAttacking:
		attack()
		enemySprite.speed_scale = 0
		return
	if xVelocity != 0 and isAttacking:
		attack()
		return
	if xVelocity == 0 and getAnimationType():
		die()
		return
	if xVelocity != 0 and getAnimationType():
		walk()
	
func setGuyIndex(newGuyIndex:int):
	guyIndex = newGuyIndex

func attack():
	if getAnimationType() == "gun":
		return
	enemySprite.play("gun" + str(guyIndex))
	enemySprite.speed_scale = 1
	
func walk():
	if getAnimationType() == "walk":
		return
	enemySprite.play("walk" + str(guyIndex))
	enemySprite.speed_scale = 1

func explode():
	explosion.visible = true
	explosion.play("explode")
	enemySprite.visible = false

func die():
	if getAnimationType() == "motionless":
		return
	enemySprite.play("motionless" + str(guyIndex))
	enemySprite.speed_scale = 1
	

func getAnimationType() ->String:
	if (enemySprite.animation == null):
		return "none"
	if (enemySprite.animation.contains("walk")):
		return "walk"
	if (enemySprite.animation.contains("motionless")):
		return "motionless"
	return enemySprite.animation
