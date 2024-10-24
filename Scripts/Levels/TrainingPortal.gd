extends Area2D

func _ready():
	# Connect to the signal that is emitted when a body enters the area
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "player":
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_Selection.tscn")
