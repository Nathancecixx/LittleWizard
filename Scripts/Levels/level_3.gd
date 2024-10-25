extends Node2D

@onready var player = $player
var respawn

func _ready() -> void:
	player.Set_Clamp(6336, 1536)
	respawn = player.global_position
	Global.level_3_complete = true
	$NPC_Dialog.timeline = "bug3_npc"
	$NPC_Dialog.remove_timeline_signal = "null"
	Dialogic.signal_event.connect(_on_dialogic_signal)


func _process(_delta: float) -> void:
	pass


func _on_dialogic_signal(argument: String):

	if (argument=="end_dialog"):
		$NPC_Dialog.timeline = "bug3_retalk"
