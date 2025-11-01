class_name AttackComponent
extends Node

@export_subgroup("Nodes")
@export var grabHitbox:Area2D
@export var animation_component: AnimationComponent

var holdingPrey = false
var hasGrabbed = false
var prey
var zombies = []

func getHasGrabbed():
	return hasGrabbed
	
func getHoldingPrey():
	return holdingPrey

func handle_grab():
	hasGrabbed = !hasGrabbed
	if !holdingPrey:
		if hasGrabbed:
			var collidingBodies = grabHitbox.get_overlapping_bodies()
			for body in collidingBodies:
				var parent = body.get_parent()
				if parent != null and parent is Enemy:
					holdingPrey = true
					prey = parent
					(prey as Enemy).setGrabbed(true)
					return
			#wiffed the grab
			await get_tree().create_timer(0.5).timeout
			hasGrabbed = false
			animation_component.handle_grab(true)
	else:
		(prey as Enemy).setGrabbed(false)
		holdingPrey = false
		
func handle_kill():
	(prey as Enemy).kill()
	await get_tree().create_timer(1).timeout
	holdingPrey = false
	hasGrabbed = false
	
func handle_infect():
	(prey as Enemy).infect()
	zombies.append(prey)
	await get_tree().create_timer(0.75).timeout
	holdingPrey = false
	hasGrabbed = false
