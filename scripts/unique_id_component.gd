class_name UniqueIdComponent
extends Node

var uid:int

func _ready() -> void:
	uid = randi()

func getUID() ->int:
	return uid
