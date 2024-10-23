extends Node2D

@onready var player : CharacterBody2D = $player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.Set_Clamp(5000, 50000)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
