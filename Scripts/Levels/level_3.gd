extends Node2D

@onready var player = $player
var respawn

func _ready() -> void:
	player.Set_Clamp(6336, 1536)
	respawn = player.global_position


func _process(_delta: float) -> void:
	pass
