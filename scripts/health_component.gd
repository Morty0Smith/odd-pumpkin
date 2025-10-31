class_name HealthComponent
extends Node

@export var maxHealth:int = 3
var health:int

func _ready() -> void:
	health = maxHealth

func add_health(addedHealth:int, ui_manager:UIManager):
	health += addedHealth
	ui_manager.setLives(health)
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
