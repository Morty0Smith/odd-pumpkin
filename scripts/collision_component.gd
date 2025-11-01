class_name CollisionComponent
extends Node

func handle_collision(body: CharacterBody2D, delta: float) -> void:
	var push_force = body.push_force
	var damping = body.damping
	for index in body.get_slide_collision_count():
		var collision: KinematicCollision2D = body.get_slide_collision(index)
		var colName = collision.get_collider().name
		body.velocity += collision.get_normal() * collision.get_collider_velocity().length() * push_force * delta
		var length = body.velocity.length()
		
		if(colName != "Player"):
			body.velocity = body.velocity * damping

		if (length <= 22):
			body.velocity = Vector2.ZERO

		if body.killWhenDroppedOntoEnemy != null and body.killWhenDroppedOntoEnemy:
			var parent = collision.get_collider().get_parent()
			if (parent != null):
				if(parent is Enemy and (-body.velocity.y) > body.speedNeededToKill):
					collision.get_collider().get_parent().kill()
