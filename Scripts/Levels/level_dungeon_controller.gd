extends Node2D

@onready var player = $player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.Set_Clamp(6400, 1494)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Global.reputation = 1
	pass
