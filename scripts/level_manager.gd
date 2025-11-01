extends Node

@export var thisSceneName: String
var lastLevel:String
var configPath = "user://save.ini"
var levelsUnlocked:int # how many levels were unlocked
var config:ConfigFile = null

func _ready() -> void:
	print("doingStuff")
	config = getConfig()
	print(thisSceneName)
	
	readSaveData()
	setLastLvl()

func getConfig()->ConfigFile:
	config = ConfigFile.new()
	var err = config.load(configPath)
	# file doesnt exist yet -> create it 
	if err != OK:
		levelsUnlocked = 0
		config.set_value("data","levelsUnlocked",0)
		config.save(configPath)
		print("saved!")
	return config
	

func setLastLvl():
	if(thisSceneName.contains("level")):
		print("saving lastLvl")
		config.set_value("data","lastLevel",thisSceneName)
		config.save(configPath)

func readSaveData():#
	var val = config.get_value("data","lastLevel")
	if val != null:
		lastLevel = val
	val = config.get_value("data","levelsUnlocked")
	if val != null:
		levelsUnlocked = val

func switchToScene(sceneName:String):
	get_tree().change_scene_to_file("res://scenes/"+sceneName+".tscn")

func unlockNextLevel():
	config = getConfig()
	levelsUnlocked += 1
	config.set_value("data","levelsUnlocked",levelsUnlocked)
	config.save(configPath)

func _on_button_up(action: String) -> void:
	print(action)
	var scene = action
	if(action == "restart"):
		scene = lastLevel
	print(scene)
	switchToScene(scene)
