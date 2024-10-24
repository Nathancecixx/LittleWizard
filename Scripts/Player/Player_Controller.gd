extends CharacterBody2D

class_name PlatformerController2D

signal jumped(is_ground_jump: bool)
signal hit_ground()


# Set these to the name of your action (in the Input Map)
## Name of input action to move left.
@export var input_left : String = "move_left"
## Name of input action to move right.
@export var input_right : String = "move_right"
## Name of input action to jump.
@export var input_jump : String = "jump"
## Name of input action to cast fireball
@export var input_fireball : String = "fireball"

## Fireball variable so character can instantiate it
var fireball = load("res://Scenes/Objects/fireball.tscn")


@onready var animations = $AnimationPlayer
@onready var timer = $Fireball_Timer

const DEFAULT_MAX_JUMP_HEIGHT = 150
const DEFAULT_MIN_JUMP_HEIGHT = 60
const DEFAULT_DOUBLE_JUMP_HEIGHT = 100
const DEFAULT_JUMP_DURATION = 0.3
const CAST_FIREBALL_SPEED = 700
const ATTACK_DELAY = 0.2

#Reputation
@export var reputation: int = 0:
	get:
		return reputation
	set(value):
		print("Setting reputation to: ", value)
		reputation = value


var _max_jump_height: float = DEFAULT_MAX_JUMP_HEIGHT
## The max jump height in pixels (holding jump).
@export var max_jump_height: float = DEFAULT_MAX_JUMP_HEIGHT: 
	get:
		return _max_jump_height
	set(value):
		_max_jump_height = value
	
		default_gravity = calculate_gravity(_max_jump_height, jump_duration)
		jump_velocity = calculate_jump_velocity(_max_jump_height, jump_duration)
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)
			

var _min_jump_height: float = DEFAULT_MIN_JUMP_HEIGHT
## The minimum jump height (tapping jump).
@export var min_jump_height: float = DEFAULT_MIN_JUMP_HEIGHT: 
	get:
		return _min_jump_height
	set(value):
		_min_jump_height = value
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)



var _double_jump_height: float = DEFAULT_DOUBLE_JUMP_HEIGHT
## The height of your jump in the air.
@export var double_jump_height: float = DEFAULT_DOUBLE_JUMP_HEIGHT:
	get:
		return _double_jump_height
	set(value):
		_double_jump_height = value
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		

var _jump_duration: float = DEFAULT_JUMP_DURATION
## How long it takes to get to the peak of the jump in seconds.
@export var jump_duration: float = DEFAULT_JUMP_DURATION:
	get:
		return _jump_duration
	set(value):
		_jump_duration = value
	
		default_gravity = calculate_gravity(max_jump_height, jump_duration)
		jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
		double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
		release_gravity_multiplier = calculate_release_gravity_multiplier(
				jump_velocity, min_jump_height, default_gravity)
		
## Multiplies the gravity by this while falling.
@export var falling_gravity_multiplier = 1.5
## Amount of jumps allowed before needing to touch the ground again. Set to 2 for double jump.
@export var max_jump_amount = 2
@export var max_acceleration = 10000
@export var friction = 20
@export var can_hold_jump : bool = false
## You can still jump this many seconds after falling off a ledge.
@export var coyote_time : float = 0.1
## Pressing jump this many seconds before hitting the ground will still make you jump.
## Only neccessary when can_hold_jump is unchecked.
@export var jump_buffer : float = 0.1
@export var direction : String = "right"


# Example of passed through param
#@export var test : bool = true:
	#set(value):
		#print("CAHNGE: ", value)
		#test = value
		

# These will be calcualted automatically
# Gravity will be positive if it's going down, and negative if it's going up
var default_gravity : float
var jump_velocity : float
var double_jump_velocity : float
# Multiplies the gravity by this when we release jump
var release_gravity_multiplier : float


var jumps_left : int
var holding_jump := false
var stop_inputs = false
var casting = false


enum JumpType {NONE, GROUND, AIR}
## The type of jump the player is performing. Is JumpType.NONE if they player is on the ground.
var current_jump_type: JumpType = JumpType.NONE

# Used to detect if player just hit the ground
var _was_on_ground: bool

var acc = Vector2()

# coyote_time and jump_buffer must be above zero to work. Otherwise, godot will throw an error.
@onready var is_coyote_time_enabled = coyote_time > 0
@onready var is_jump_buffer_enabled = jump_buffer > 0
@onready var coyote_timer = Timer.new()
@onready var jump_buffer_timer = Timer.new()

@onready var idle : AnimatedSprite2D = $Idle_anim
@onready var walk : AnimatedSprite2D = $Walk_anim
@onready var cast : AnimatedSprite2D = $Cast_Fireball_anim
var walkLeft : bool = false

func _init():
	default_gravity = calculate_gravity(max_jump_height, jump_duration)
	jump_velocity = calculate_jump_velocity(max_jump_height, jump_duration)
	double_jump_velocity = calculate_jump_velocity2(double_jump_height, default_gravity)
	release_gravity_multiplier = calculate_release_gravity_multiplier(
			jump_velocity, min_jump_height, default_gravity)
	

func _ready():
	self.add_to_group("player")  # Add the character to the "player" group used for detecting object type when colliding with portal

	if is_coyote_time_enabled:
		add_child(coyote_timer)
		coyote_timer.wait_time = coyote_time
		coyote_timer.one_shot = true
	
	if is_jump_buffer_enabled:
		add_child(jump_buffer_timer)
		jump_buffer_timer.wait_time = jump_buffer
		jump_buffer_timer.one_shot = true

	Dialogic.signal_event.connect(_on_dialogic_signal)
	$Fireball_Timer.wait_time = ATTACK_DELAY

	idle.play()
	walk.play()
	cast.play()


func _input(_event):
	acc.x = 0


	if (!stop_inputs):
	
		## Prevents character from moving if they are holding A and D at the same time
		if (Input.is_action_pressed(input_right) && Input.is_action_pressed(input_left)):
			pass

		elif (Input.is_action_pressed(input_right)):
			acc.x = max_acceleration
			direction = "right"

		elif (Input.is_action_pressed(input_left)):
			acc.x = -max_acceleration
			direction = "left"

		if (Input.is_action_just_pressed(input_jump) && !(casting)):
			holding_jump = true
			start_jump_buffer_timer()
		
			if (not can_hold_jump and can_ground_jump()) or (can_double_jump() && Global.reputation>0):
				jump()

		if Input.is_action_just_released(input_jump):
			holding_jump = false

		if (Input.is_action_just_pressed(input_fireball) && !(casting) && Global.reputation<0):
			if (is_on_floor()):
				Cast_Fireball()
				
		


func _physics_process(delta):
	if is_coyote_timer_running() or current_jump_type == JumpType.NONE:
		jumps_left = max_jump_amount
	if is_feet_on_ground() and current_jump_type == JumpType.NONE:
		start_coyote_timer()
		
	# Check if we just hit the ground this frame
	if not _was_on_ground and is_feet_on_ground():
		current_jump_type = JumpType.NONE
		if is_jump_buffer_timer_running() and not can_hold_jump: 
			jump()
		
		hit_ground.emit()
	
	
	# Cannot do this in _input because it needs to be checked every frame
	if Input.is_action_pressed(input_jump):
		if can_ground_jump() and can_hold_jump:
			jump()
	
	var gravity = apply_gravity_multipliers_to(default_gravity)
	acc.y = gravity
	
	# Apply friction
	velocity.x *= 1 / (1 + (delta * friction))
	velocity += acc * delta
	
	determine_animation()
	
	_was_on_ground = is_feet_on_ground()
	move_and_slide()


## Use this instead of coyote_timer.start() to check if the coyote_timer is enabled first
func start_coyote_timer():
	if is_coyote_time_enabled:
		coyote_timer.start()

## Use this instead of jump_buffer_timer.start() to check if the jump_buffer is enabled first
func start_jump_buffer_timer():
	if is_jump_buffer_enabled:
		jump_buffer_timer.start()

## Use this instead of `not coyote_timer.is_stopped()`. This will always return false if 
## the coyote_timer is disabled
func is_coyote_timer_running():
	if (is_coyote_time_enabled and not coyote_timer.is_stopped()):
		return true
	
	return false

## Use this instead of `not jump_buffer_timer.is_stopped()`. This will always return false if 
## the jump_buffer_timer is disabled
func is_jump_buffer_timer_running():
	if is_jump_buffer_enabled and not jump_buffer_timer.is_stopped():
		return true
	
	return false


func can_ground_jump() -> bool:
	if jumps_left > 0 and current_jump_type == JumpType.NONE:
		return true
	elif is_coyote_timer_running():
		return true
	
	return false


func can_double_jump():
	if jumps_left <= 1 and jumps_left == max_jump_amount:
		# Special case where you've fallen off a cliff and only have 1 jump. You cannot use your
		# first jump in the air
		return false
	
	if jumps_left > 0 and not is_feet_on_ground() and coyote_timer.is_stopped():
		return true
	
	return false


## Same as is_on_floor(), but also returns true if gravity is reversed and you are on the ceiling
func is_feet_on_ground():
	if is_on_floor() and default_gravity >= 0:
		return true
	if is_on_ceiling() and default_gravity <= 0:
		return true
	
	return false


## Perform a ground jump, or a double jump if the character is in the air.
func jump():
	$Jump_SFX.play()
	if can_double_jump():
		double_jump()
	else:
		ground_jump()


## Perform a double jump without checking if the player is able to.
func double_jump():
	if jumps_left == max_jump_amount:
		# Your first jump must be used when on the ground.
		# If your first jump is used in the air, an additional jump will be taken away.
		jumps_left -= 1
	
	velocity.y = -double_jump_velocity
	current_jump_type = JumpType.AIR
	jumps_left -= 1
	jumped.emit(false)


## Perform a ground jump without checking if the player is able to.
func ground_jump():
	velocity.y = -jump_velocity
	current_jump_type = JumpType.GROUND
	jumps_left -= 1
	coyote_timer.stop()
	jumped.emit(true)


func apply_gravity_multipliers_to(gravity) -> float:
	if velocity.y * sign(default_gravity) > 0: # If we are falling
		gravity *= falling_gravity_multiplier
	
	# if we released jump and are still rising
	elif velocity.y * sign(default_gravity) < 0:
		if not holding_jump: 
			if not current_jump_type == JumpType.AIR: # Always jump to max height when we are using a double jump
				gravity *= release_gravity_multiplier # multiply the gravity so we have a lower jump
	
	
	return gravity


## Calculates the desired gravity from jump height and jump duration.  [br]
## Formula is from [url=https://www.youtube.com/watch?v=hG9SzQxaCm8]this video[/url] 
func calculate_gravity(p_max_jump_height, p_jump_duration):
	return (2 * p_max_jump_height) / pow(p_jump_duration, 2)


## Calculates the desired jump velocity from jump height and jump duration.
func calculate_jump_velocity(p_max_jump_height, p_jump_duration):
	return (2 * p_max_jump_height) / (p_jump_duration)


## Calculates jump velocity from jump height and gravity.  [br]
## Formula from 
## [url]https://sciencing.com/acceleration-velocity-distance-7779124.html#:~:text=in%20every%20step.-,Starting%20from%3A,-v%5E2%3Du[/url]
func calculate_jump_velocity2(p_max_jump_height, p_gravity):
	return sqrt(abs(2 * p_gravity * p_max_jump_height)) * sign(p_max_jump_height)


## Calculates the gravity when the key is released based off the minimum jump height and jump velocity.  [br]
## Formula is from [url]https://sciencing.com/acceleration-velocity-distance-7779124.html[/url]
func calculate_release_gravity_multiplier(p_jump_velocity, p_min_jump_height, p_gravity):
	var release_gravity = pow(p_jump_velocity, 2) / (2 * p_min_jump_height)
	return release_gravity / p_gravity


## Returns a value for friction that will hit the max speed after 90% of time_to_max seconds.  [br]
## Formula from [url]https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3[/url]
func calculate_friction(time_to_max):
	return 1 - (2.30259 / time_to_max)


## Formula from [url]https://www.reddit.com/r/gamedev/comments/bdbery/comment/ekxw9g4/?utm_source=share&utm_medium=web2x&context=3[/url]
func calculate_speed(p_max_speed, p_friction):
	return (p_max_speed / p_friction) - p_max_speed

var velThresh : int = 30

func determine_animation():
	idle.visible = false
	walk.visible = false
	cast.visible = false
	
	if (casting):
		
		var cast_dir = false
		cast.visible = true
		
		if (direction=="left"):
			cast_dir = true
		elif (direction=="right"):
			cast_dir = false
		cast.flip_h = cast_dir
	else:
		# Checks if velocity is below threshhold
		if (-velThresh <= velocity.x and velocity.x <= velThresh):
			idle.visible = true
		elif (velocity.x > velThresh):
			walkLeft = false
			walk.visible = true
		elif (velocity.x < -velThresh):
			walkLeft = true
			walk.visible = true
		walk.flip_h = walkLeft

func Set_Clamp(Max_X, Max_Y):
	var Camera_Instance = $Camera2D
	
	Camera_Instance.Set_Clamp(Max_X, Max_Y)
	pass

func Cast_Fireball():

	$Fireball_Timer.start()
	cast.set_frame_and_progress(0,0)
	casting = true
	acc.x=0
	$Fire_Ball_SFX.play()

func Create_Fireball():

	var Fireball = fireball.instantiate()
	if (direction=="right"):
		Fireball.position = $right_fireball_marker.global_position
		Fireball.set_speed(CAST_FIREBALL_SPEED)
	else:
		Fireball.position = $left_fireball_marker.global_position
		Fireball.set_speed(-1*CAST_FIREBALL_SPEED)
	get_node("/root").add_child(Fireball)


func _on_fireball_timer_timeout():
	$Fireball_Timer.stop()
	casting=false
	Create_Fireball()

func _on_dialogic_signal(argument: String):

	if (argument=="start_dialog"):
		stop_inputs=true
	elif (argument=="end_dialog"):
		stop_inputs=false

	## Arguments for losing/gaining reputation
	elif (argument=="bad"):
		Global.reputation -= 0.50001
	elif (argument=="good"):
		Global.reputation += 0.50001
