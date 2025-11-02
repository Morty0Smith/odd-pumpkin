extends Node

@export var thisSceneName: String
@export var levelButtons: VBoxContainer
var showMinAmountOfLevels = 1 # show atleast this many buttons on startscreen
var lastLevel:String
var configPath = "user://save.ini"
var levelsUnlocked:int # how many levels were unlocked
var config:ConfigFile = null

func _ready() -> void:
	config = getConfig()
	
	readSaveData()
	setLastLvl()
	
	if thisSceneName == "startmenu":
		if levelButtons == null:
			print("buttonGroup not set!!!")
			return
		
		# first hide all buttons
		for child in levelButtons.get_children():
			child.hide()
		
		#levelsUnlocked = 1
		# in case there are more levels unlocked than existing
		var levelsToUnlock = min(levelsUnlocked+showMinAmountOfLevels,levelButtons.get_child_count())
		for i in range(levelsToUnlock):
			levelButtons.get_child(i).show()
		

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

# it important to pass the scene / action as an extra argument
func _on_button_up(action: String) -> void:
	print(action)
	var scene = action
	if(action == "restart"):
		scene = lastLevel
	print(scene)
	switchToScene(scene)
