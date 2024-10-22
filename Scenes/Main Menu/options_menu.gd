class_name Main_menu
extends Control
func _on_volume_pressed() -> void:
	pass # Replace with function body.
	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu/Main_menu.tscn")
