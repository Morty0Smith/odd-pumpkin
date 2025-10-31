class_name CrosshairComponent
extends AnimatedSprite2D

var enemy_uid:int

func setUID(uid:int):
	enemy_uid = uid
	
func getUID() ->int:
	return enemy_uid
