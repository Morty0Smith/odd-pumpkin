class_name LevelEnd
extends Node2D

var player:Node2D
var level_manager:LevelManager
var has_swtiched:bool = false

func _ready() -> void:
	var sceneName:String = get_tree().current_scene.name
	player = get_node("/root/" + sceneName +  "/Player")
	level_manager = get_node("/root/" + sceneName +  "/LevelManager")

func _physics_process(delta: float) -> void:
	if !has_swtiched:
		if player.global_position.y > self.global_position.y:
			level_manager.switchToScene("startmenu")
			level_manager.unlockNextLevel()
			has_swtiched = true
