extends Area2D


var ignited: bool = false

@export var ignition_time: float = 15:
	get:
		return ignition_time
	set(value):
		ignition_time = value
		
@onready var animations = $Ignitable_Animations

# Called when the node enters the scene tree for the first time.
func _ready():
	
	## starts unlit
	animations.play("unlit")
	ignited = false
	$Ignite_Timer.wait_time = ignition_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float): 
	pass
	
func is_ignited():
	return ignited
	
func ignite():
	
	$Ignite_Timer.start()
	ignited=true
	animations.play("ignited")


func _on_ignite_timer_timeout():
	
	$Ignite_Timer.stop()
	animations.play("unlit")
	ignited = false


func _on_area_entered(area: Area2D) -> void:
	
	if (area.is_in_group("fireball")):
		ignite()
