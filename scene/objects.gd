class_name Objects
extends CharacterBody2D

@export_subgroup("Componets")
@export var gravity_component: GravityComponent
@export var push_force: int = 50
@export var damping: float = 0.98
@export var speedNeededToKill: int = 50

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	for index in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(index)
		var colName = collision.get_collider().name
		velocity += collision.get_normal() * collision.get_collider_velocity().length() * push_force * delta
		var length = velocity.length()
		
		if(colName != "Player"):
			velocity = velocity * damping
		if(colName == "EnemyBody" and (-velocity.y) > speedNeededToKill):
			collision.get_collider().get_parent().kill()
		if (length <= 22):
			velocity = Vector2.ZERO
		

	move_and_slide()
