extends Control

@onready var wizard = $Wizard
@onready var good_button = $Button_Good
@onready var good_anim = $Button_Good/Good_Animation
@onready var evil_button = $Button_Evil
@onready var evil_anim = $Button_Evil/Evil_Animation

func _onready():
	wizard.play()
	good_anim.visible = false
	good_anim.pause()
	evil_anim.visible = false
	evil_anim.pause()

func _on_good_hovered() -> void:
	good_anim.visible = true
	good_anim.play()

func _on_good_exited() -> void:
	good_anim.visible = false
	good_anim.pause()
	
func _on_evil_hovered() -> void:
	evil_anim.visible = true
	evil_anim.play()

func _on_evil_exited() -> void:
	evil_anim.visible = false
	evil_anim.pause()
