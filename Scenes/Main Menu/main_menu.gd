extends Control

var isBgOn = true

func _on_play_pressed() -> void:

	$AudioStreamPlayer2D.stop()
	isBgOn = false
	$Menu_Click_SFX.play()
	await get_tree().create_timer(1, false, false, true).timeout
	get_tree().change_scene_to_file("res://Scenes/Animations/IntroManager.tscn")

func _on_options_pressed() -> void:
	$AudioStreamPlayer2D.stop()
	isBgOn = false
	$Menu_Click_SFX.play()
	await get_tree().create_timer(1, false, false, true).timeout
	get_tree().change_scene_to_file("res://Scenes/Main Menu/Options_menu.tscn")

func _on_quit_pressed() -> void:
	$AudioStreamPlayer2D.stop()
	isBgOn = false
	$Menu_Click_SFX.play()
	await get_tree().create_timer(1, false, false, true).timeout
	get_tree().quit()
	
	
func _process(delta: float) -> void:
	if $AudioStreamPlayer2D.playing == false && isBgOn :
		$AudioStreamPlayer2D.play()
	pass
