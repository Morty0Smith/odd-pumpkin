class_name UIManager
extends Node

@export var eye_Display:TextureRect
@export var Hearts:Array[TextureRect]

var eye_texture:AtlasTexture
var seenLevel:int
var seenLevelAssignedUID:int

func _ready() -> void:
	eye_texture = eye_Display.texture as AtlasTexture

func switchToAtlasFrame(texture:AtlasTexture, sidelength:int, frame:int):
	texture.region = Rect2(Vector2(sidelength*frame,0),Vector2(sidelength,sidelength))

func setSeenLevel(level:int, UID:int):
	switchToAtlasFrame(eye_texture,16,seenLevel)
	seenLevel = level
	seenLevelAssignedUID = UID

func resetSeenLevel(UID:int):
	if (seenLevel == 2 and UID == seenLevelAssignedUID):
		setSeenLevel(1,UID)

func getSeenLevel() ->int:
	return seenLevel

func setLives(lives:int):
	lives = min(Hearts.size(),lives)
	for i in Hearts.size():
		var heart_texture:AtlasTexture = Hearts.get(i).texture as AtlasTexture
		if i < lives:
			print("true")
			switchToAtlasFrame(heart_texture,16,0)
		else:
			print("false")
			switchToAtlasFrame(heart_texture,16,1)
