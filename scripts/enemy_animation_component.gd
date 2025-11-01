class_name  EnemyAnimationComponent
extends Node

@export var enemySprite:AnimatedSprite2D

var guyIndex:int = 0
var isTurnedToDust

func handleAnimation(isAttacking:bool, xVelocity:float):
	if isTurnedToDust:
		handle_explode()
		return
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
	enemySprite.play("gun")
	enemySprite.speed_scale = 1
	
func walk():
	if getAnimationType() == "walk":
		return
	enemySprite.play("walk" + str(guyIndex))
	enemySprite.speed_scale = 1

func die():
	if getAnimationType() == "motionless":
		return
	enemySprite.play("motionless" + str(guyIndex))
	enemySprite.speed_scale = 1
	
func handle_explode():
	
	if getAnimationType() == "explode":
		return
	enemySprite.apply_scale(Vector2(4,4))
	enemySprite.play("explode")

func getAnimationType() ->String:
	if (enemySprite.animation == null):
		return "none"
	if (enemySprite.animation.contains("walk")):
		return "walk"
	if (enemySprite.animation.contains("motionless")):
		return "motionless"
	return enemySprite.animation
