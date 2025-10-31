extends Node

@export var eye_Display:TextureRect

var eye_texture:AtlasTexture

func _ready() -> void:
	eye_texture = eye_Display.texture as AtlasTexture
	switchToAtlasFrame(eye_texture,16,2)

func switchToAtlasFrame(texture:AtlasTexture, sidelength:int, frame:int):
	texture.region = Rect2(Vector2(sidelength*frame,0),Vector2(sidelength,sidelength))

func setSeenLevel(seenLevel:int):
	switchToAtlasFrame(eye_texture,16,seenLevel)
