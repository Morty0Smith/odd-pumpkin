class_name BreakableObj
extends CharacterBody2D

@export_subgroup("Componets")
@export var collision_component: CollisionComponent
@export var gravity_component: GravityComponent
@export var speedNeededToBreak: int = 50
@export var onlyBreakWhenFalling: bool = true
@export var push_force: int = 50
@export var damping: float = 0.98
@export var noiseArea:Area2D
@export var makeNoise:bool = true

var speed = 0
var doBreak = false

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	collision_component.handle_collision(self,delta)
	
	if(onlyBreakWhenFalling):
		if(velocity.y > speedNeededToBreak):
			doBreak = true
	
	for index in get_slide_collision_count():
		speed = velocity.y
		if(!onlyBreakWhenFalling):
			speed = velocity.length()
			
		if(speed > speedNeededToBreak or doBreak):
			destroy()
	move_and_slide()

func makeSomeNoise():
	for collider in noiseArea.get_overlapping_bodies():
		var parent = collider.get_parent()
		if(parent != null and parent is Enemy):
			var enemyMovement: EnemyMovement = parent.find_child("EnemyMovement")
			var enemyVision: EnemyVisionComponent = parent.find_child("enemy_vision_component")
			if(enemyMovement != null and enemyVision != null):
				if(enemyVision.castToObj(self)):
					parent.isInvestigating = true
					parent.investigationPos = self.position

func destroy():
	doBreak = false
	if makeNoise:
		makeSomeNoise()
	queue_free()
