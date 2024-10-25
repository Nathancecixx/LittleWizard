extends Node2D

@onready var player : CharacterBody2D = $player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.Set_Clamp(2560, 10000)
	$Level_1_Door_Interaction.timeline = "cant_enter"
	$Level_1_Door_Interaction.remove_timeline_signal = "null"
	$Level_2_Door_Interaction.timeline = "cant_enter"
	$Level_2_Door_Interaction.remove_timeline_signal = "null"
	$Level_3_Door_Interaction.timeline = "cant_enter"
	$Level_3_Door_Interaction.remove_timeline_signal = "null"
	$NPC_Dialog.timeline = "wizard_retalk"
	$NPC_Dialog.remove_timeline_signal = "null"
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	if (!Global.level_1_complete && !Global.level_2_complete && !Global.level_3_complete):
		$Level_1_Door_Interaction.timeline = "level_1_interact"
	if (Global.level_1_complete && !Global.level_2_complete && !Global.level_3_complete):
		$Level_2_Door_Interaction.timeline = "Level_2_interact"
	if (Global.level_1_complete && Global.level_2_complete && !Global.level_3_complete):
		$Level_3_Door_Interaction.timeline = "level_3_interact"
	if (Global.talked_to_wizard):
		$NPC_Dialog.timeline = "wizard_retalk"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_dialogic_signal(argument: String):

	if (argument=="enter_level_1"):
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_1.tscn")
	if (argument=="enter_level_2"):
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_Dungeon.tscn")
	if (argument=="enter_level_3"):
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_3.tscn")
	if (argument=="end_wizard_intro"):
		Global.talked_to_wizard = true
		$NPC_Dialog.timeline = "wizard_retalk"
		
	
