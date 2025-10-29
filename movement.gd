extends Node

@export var rollSpeed = 200
@export var walkSpeed = 100
@export var player:CharacterBody2D
@export var gravity_component: GravityComponent

func get_input():
	var input_direction = Input.get_axis("left", "right")
	player.velocity = input_direction * walkSpeed
