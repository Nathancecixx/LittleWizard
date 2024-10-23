extends Area2D

const FIREBALL_DEFAULT_SPEED = 400
const LEFT_FACING = 90
const RIGHT_FACING = 270

@onready var animations = $Fireball_Animation

@export var speed: int = FIREBALL_DEFAULT_SPEED:
	get:
		return speed
	set(value):
		speed = value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	
	## Changes the fireballs position each frame
	position = position + (transform.x * speed * delta)
	animations.play("fireball_animation")
	
	if (speed<0):
		$Fireball_Sprite.rotation_degrees = LEFT_FACING
	else:
		$Fireball_Sprite.rotation_degrees = RIGHT_FACING

## calle when the fireball collides with an object
func _on_body_entered(body: Node2D):
	
	## Deletes the object that the fireball collided with if it is a "burnable object"
	if (body.is_in_group("burnable")):
		body.queue_free()

	## Deletes the fireball when it collides with a collision box that is not the players
	if (!body.is_in_group("player")):
		queue_free()
		
## sets the speed of the fireball
func set_speed(value: int):
	speed = value
		
