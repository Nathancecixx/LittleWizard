extends Node2D

@onready var player = $player
var respawn 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.Set_Clamp(6400, 1600)
	respawn = player.global_position
	Global.level_2_complete = true
	$NPC_Dialog.timeline = "bug2_npc"
	$NPC_Dialog.remove_timeline_signal = "null"
	Dialogic.signal_event.connect(_on_dialogic_signal)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_dialogic_signal(argument: String):

	if (argument=="end_dialog"):
		$NPC_Dialog.timeline = "bug2_retalk"
