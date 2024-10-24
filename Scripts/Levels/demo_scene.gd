extends Node2D

@onready var player : CharacterBody2D = $player



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.Set_Clamp(2304, 50000)
	$NPC_Dialog.timeline = "wizard_npc"
	$NPC_Dialog.remove_timeline_signal = "null"
	Dialogic.signal_event.connect(_on_dialogic_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_dialogic_signal(argument: String):
	if (argument=="end_dialog"):
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_Selection.tscn")
