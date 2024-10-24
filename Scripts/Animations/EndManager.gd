extends Node

const CAVE_OUTRO_BAD_SCENE: PackedScene = preload("res://Scenes/Animations/Caveoutro_Bad.tscn")
const CAVE_OUTRO_GOOD_SCENE: PackedScene = preload("res://Scenes/Animations/Caveoutro_Good.tscn")

var OutroScene: Node
var AnimPlayer: AnimationPlayer

func _ready():
	
	if Global.reputation > 0 && CAVE_OUTRO_GOOD_SCENE:
		OutroScene = CAVE_OUTRO_GOOD_SCENE.instantiate()
		add_child(OutroScene)
	elif Global.reputation < 0 && CAVE_OUTRO_BAD_SCENE:
		OutroScene = CAVE_OUTRO_BAD_SCENE.instantiate()
		add_child(OutroScene)
	else:
		print("Error: Could not load Outro scene.")
		return
	
	AnimPlayer = OutroScene.get_node("AnimationPlayer")
		
	AnimPlayer.play("Forest_Scene")
		
	AnimPlayer.connect("animation_finished", Callable(self, "_first_anim_finished"))


func _first_anim_finished(anim_name):
	AnimPlayer.play("Cave_Scene")
	AnimPlayer.connect("animation_finished", Callable(self, "_second_anim_finished"))

func _second_anim_finished(anim_name):
	if anim_name == "Cave_Scene":
		# Once Scene2 animation is done, transition to the next scene
		get_tree().change_scene_to_file("res://Scenes/Main Menu/Main_menu.tscn")
