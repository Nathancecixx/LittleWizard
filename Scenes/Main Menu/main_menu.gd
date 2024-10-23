extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/Path_Selection.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main Menu/Options_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
	
	
func _process(delta: float) -> void:
	if $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.play()
	pass
