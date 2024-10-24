extends Control

class_name ttsCustom

enum charName { goodWiz, evilWiz = 13  }
#Voice code
var Voices: Array[Dictionary] = DisplayServer.tts_get_voices()

func _ready() -> void:
	print(Voices)
	pass # Replace with function body.
	
func useVoice(content:String , characterName:int) -> void:
	#var text: String = "Hello Nerosha! Happy Birthday! This is text voice mode"
	var speaker : String = Voices[characterName]["id"]
	DisplayServer.tts_speak(content,speaker)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
