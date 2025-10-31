class_name BreakableObj
extends CharacterBody2D

@export_subgroup("Componets")
@export var collision_component: CollisionComponent
@export var gravity_component: GravityComponent
@export var speedNeededToBreak: int = 50
@export var onlyBreakWhenFalling: bool = true
@export var push_force: int = 50
@export var damping: float = 0.98

var speed = 0
var doBreak = false

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	collision_component.handle_collision(self,delta)
	
	if(onlyBreakWhenFalling):
		if(velocity.y > speedNeededToBreak):
			#print(velocity.y)
			doBreak = true
			
	
	for index in get_slide_collision_count():
		#var collision: KinematicCollision2D = get_slide_collision(index)
		#var colName = collision.get_collider().name
		speed = velocity.y
		if(!onlyBreakWhenFalling):
			speed = velocity.length()
			
		if(speed > speedNeededToBreak or doBreak):
			destroy()
			
	move_and_slide()

func destroy():
	doBreak = false
	#print("BREAK")
	#print(speed)
	queue_free()
