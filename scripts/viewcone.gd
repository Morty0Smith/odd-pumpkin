class_name Viewcone
extends Node2D

@export var fov:float = 100
@export var numberRays = 10

@export var eyeRay:RayCast2D
@export var selfCollider:CollisionObject2D


func getMinPlayerDist(lookToRight:bool, playerCollider:CollisionObject2D) ->float:
	eyeRay.add_exception(selfCollider)
	eyeRay.enabled = true
	var rayDisctanceIncrement = fov/numberRays
	var directionFactor = -1 if lookToRight else 1
	var minPlayerDist:float = -1
	for i in numberRays:
		eyeRay.target_position = Vector2(10 * directionFactor,i*rayDisctanceIncrement - (fov/2))
		eyeRay.force_raycast_update()
		print(eyeRay.get_collider())
		if (eyeRay.get_collider() == playerCollider):
			var playerDistance:float = getRaycastDistance(eyeRay)
			if (minPlayerDist == -1 or playerDistance < minPlayerDist):
				minPlayerDist = playerDistance
	return minPlayerDist
		
func getRaycastDistance(ray:RayCast2D) ->float:
	var origin = ray.global_transform.origin
	var collisionPoint = ray.get_collision_point()
	return origin.distance_to(collisionPoint)
