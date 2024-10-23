extends Area2D
var target_scene = "res://Scenes/Levels/Level_Selection.tscn" # Scene to transition to

var scene_change_triggered = false  # Flag to track if scene change has been triggered

#func _ready() -> void:
	#print("Portal Ready!") # Debugging: Check if the script is running 

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		await get_tree().create_timer(0.3).timeout
		_next_scene()
		
func _on_body_exited(body) -> void:
	if body.is_in_group("player"):
		_next_scene()
		
func _next_scene() -> void:
	var player_node = get_tree().get_nodes_in_group("player")[0]
	if player_node and not scene_change_triggered:
		scene_change_triggered = true  # Set the flag to prevent further calls
		
		# Access global variable
		Global.reputation += 1

		print("PLAYER REPUTATION UPDATED:", Global.reputation) 
		get_tree().change_scene_to_file(target_scene)
	
