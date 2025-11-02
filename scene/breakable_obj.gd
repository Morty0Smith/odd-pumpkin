class_name BreakableObj
extends CharacterBody2D

@export var break_sound_effect:AudioStreamPlayer2D
@export var collision_component: CollisionComponent
@export var gravity_component: GravityComponent
@export var speedNeededToKill: int = 50
@export var killWhenDroppedOntoEnemy: bool = true
@export var speedNeededToBreak: int = 50
@export var unbreakable: bool = false
@export var onlyBreakWhenFalling: bool = true
@export var push_force: int = 50
@export var damping: float = 0.98
@export var noiseArea:Area2D
@export var makeNoise:bool = true
@export var investigateWaitTime:float = 3

var speed = 0
var doBreak = false
var isBroken = false

func _physics_process(delta: float) -> void:
	if isBroken:
		return
	gravity_component.handle_gravity(self, delta)
	collision_component.handle_collision(self,delta)
	
	if(onlyBreakWhenFalling):
		if(velocity.y > speedNeededToBreak):
			doBreak = true
	
	if get_slide_collision_count() > 0:
		speed = velocity.y
		if(!onlyBreakWhenFalling):
			speed = velocity.length()
			
		if(speed > speedNeededToBreak or doBreak):
			fellAction(delta)
		
	move_and_slide()

func makeSomeNoise():
	break_sound_effect.play(0.1)
	for collider in noiseArea.get_overlapping_bodies():
		var parent = collider.get_parent()
		if(parent != null and parent is Enemy):
			var enemyMovement: EnemyMovement = parent.find_child("EnemyMovement")
			var enemyVision: EnemyVisionComponent = parent.find_child("enemy_vision_component")
			if(enemyMovement != null and enemyVision != null):
				if true:
					parent.isInvestigating = true
					parent.investigationPos = self.position
					parent.investigatingWaitTime = investigateWaitTime
					parent.audio_player_component.playSoundEffectWithName("huh")

func fellAction(delta):
	doBreak = false
	if makeNoise:
		makeSomeNoise()
	if !unbreakable:
		isBroken = true
		collision_component.handle_collision(self,delta)
		collision_component.queue_free()
		gravity_component.queue_free()
		self.get_node("CollisionShape2D").queue_free()
