extends Node2D

var Level_Height = 340
var Level_Width = 3304

func _ready():
	var player = $player
	
	# Pass the parameter (e.g., speed)
	player.Set_Clamp(Level_Width, Level_Height)
