extends Button

signal choice_made()

func _on_pressed() -> void:
	#get_tree().change_scene_to_file("res://Scenes/Levels/Level_Selection.tscn")
	emit_signal("choice_made")
	Global.reputation = 0.5
