class_name AudioPlayerComponent
extends AudioStreamPlayer2D

@export var soundEffectsWithNames:Dictionary[String,AudioStream]

func playSoundEffectWithName(soundEffect:String):
	if soundEffectsWithNames[soundEffect] == null:
		print("Errror: Invalid sound effect name")
		return
	self.stream  = soundEffectsWithNames[soundEffect]
	self.play(0)
