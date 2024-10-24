extends Node2D

@onready var player = $player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.Set_Clamp(6400, 1494)
	Global.level_1_complete = true
	$NPC_Dialog.timeline = "bug1_npc"
	$NPC_Dialog.remove_timeline_signal = "null"
	Dialogic.signal_event.connect(_on_dialogic_signal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_dialogic_signal(argument: String):

	if (argument=="end_dialog"):
		$NPC_Dialog.timeline = "bug1_retalk"
