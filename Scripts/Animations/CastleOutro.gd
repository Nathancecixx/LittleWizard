extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var animationPlayer = $AnimationPlayer
	
	animationPlayer.play("Forest_Scene")
