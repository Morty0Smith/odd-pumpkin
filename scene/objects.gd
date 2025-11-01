class_name Objects
extends CharacterBody2D

@export_subgroup("Componets")
@export var collision_component: CollisionComponent
@export var gravity_component: GravityComponent
@export var speedNeededToKill: int = 50
@export var push_force: int = 50
@export var damping: float = 0.98

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	collision_component.handle_collision(self,delta)
	
	for index in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(index)
		var parent = collision.get_collider().get_parent()
		if (parent != null):
			if(parent is Enemy and (-velocity.y) > speedNeededToKill):
				collision.get_collider().get_parent().kill()
			
	move_and_slide()
