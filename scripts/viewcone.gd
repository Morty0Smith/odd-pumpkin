class_name Viewcone
extends Node2D

@export var fov:float = 100
@export var numberRays = 10

@export var ray:RayCast2D
@export var selfCollider:CollisionObject2D


func getMinPlayerDist(lookToRight:bool, playerCollider:CollisionObject2D) ->float:
	ray.add_exception(selfCollider)
	ray.enabled = true
	var rayDisctanceIncrement = fov/numberRays
	var directionFactor = -1 if lookToRight else 1
	var minPlayerDist:float = -1
	for i in numberRays:
		ray.target_position = Vector2(10 * directionFactor,i*rayDisctanceIncrement - (fov/2))
		ray.force_raycast_update()
		print(ray.get_collider())
		if (ray.get_collider() == playerCollider):
			var playerDistance:float = getRaycastDistance(ray)
			if (minPlayerDist == -1 or playerDistance < minPlayerDist):
				minPlayerDist = playerDistance
	return minPlayerDist
		
func getRaycastDistance(ray:RayCast2D) ->float:
	var origin = ray.global_transform.origin
	var collisionPoint = ray.get_collision_point()
	return origin.distance_to(collisionPoint)

func testRaycast():
	ray.force_raycast_update()
	ray.force_update_transform()
	print(ray.get_collider())
