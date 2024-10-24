extends Node

const CASTLE_INTRO_SCENE: PackedScene = preload("res://Scenes/Animations/CastleIntro.tscn")
const PATH_SELECTION_SCENE: PackedScene = preload("res://Scenes/Menus/Path_Selection.tscn")

var CastleIntro: Node
var AnimPlayer: AnimationPlayer
var PathSelection: Node

func _ready():
	if CASTLE_INTRO_SCENE:
		CastleIntro = CASTLE_INTRO_SCENE.instantiate()
		add_child(CastleIntro)
	
		AnimPlayer = CastleIntro.get_node("AnimationPlayer")
		
		AnimPlayer.play("Scene1")
		
		# Connect the animation finished signal to proceed with the transition
		AnimPlayer.connect("animation_finished", Callable(self, "_first_anim_finished"))
	else:
		print("Error: Could not load CastleIntro scene.")

func _first_anim_finished(anim_name):
	if anim_name == "Scene1":
		# Free CastleIntro when it's no longer needed
		CastleIntro.queue_free()
		
		# Instance the PathSelection scene
		if PATH_SELECTION_SCENE:
			PathSelection = PATH_SELECTION_SCENE.instantiate()
			add_child(PathSelection)
			
			# Connect buttons' signals to handle the player's choice
			for button in PathSelection.get_children():
				if button is Button:
					button.connect("choice_made", Callable(self, "_on_choice_made"))
		else:
			print("Error: Could not load PathSelection scene.")

func _on_choice_made():
	
	# Free the PathSelection node when done
	PathSelection.queue_free()
	
	CastleIntro = CASTLE_INTRO_SCENE.instantiate()
	add_child(CastleIntro)
	
	AnimPlayer = CastleIntro.get_node("AnimationPlayer")
	
	AnimPlayer.play("Scene2")
	
	# Connect animation finished signal to transition after Scene2
	AnimPlayer.connect("animation_finished", Callable(self, "_second_anim_finished"))

func _second_anim_finished(anim_name):
	if anim_name == "Scene2":
		# Once Scene2 animation is done, transition to the next scene
		get_tree().change_scene_to_file("res://Scenes/Levels/Tutorial.tscn")
