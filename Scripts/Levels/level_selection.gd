extends Node2D

@onready var player : CharacterBody2D = $player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.Set_Clamp(2560, 10000)
	$Level_1_Door_Interaction.timeline = "level_1_interact"
	$Level_1_Door_Interaction.remove_timeline_signal = "null"
	$test_dialog.timeline = "test_timeline"
	$test_dialog.remove_timeline_signal = "end_test"
	Dialogic.signal_event.connect(_on_dialogic_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_dialogic_signal(argument: String):

	if (argument=="enter_level_1"):
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_1.tscn")
