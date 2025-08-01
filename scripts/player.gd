class_name Player
extends CharacterBody2D
# hi guys

# player movement:
# coyote time
# jump
# dash - with cd ofc, use a raycast
# - i rlly liked how slash had a little jump every slash, want to implement that in as well
# - just add y velocity by a bit
# double jump
# grapple = idk how to implement this

# so anyway i did copy and paste
# no coyote time, double jump more than makes up for it; either have one or the other

# constants that determine player movement basics
const ACCEL = 20
const JUMP_HEIGHT = -300
const MAX_SPEED = 170

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D # texture
@onready var sword: Node2D = $Sword

# pve things
var health = 100

# dash
var dash_cd = 0
var dash_stun_threshold = 0.8
var has_dashed = false

# double jump
var air_jumps_left = 0
# coyote time
var airtime = 999

# general prep
var can_input = true
var direction = 0

func _physics_process(delta: float) -> void:
	# tick regardless of input

	# tick down some cds
	# remember: delta is approx 1/60, so between 0 and 1
	# so any cds are all in seconds (set cd to 1 = cd is 1 second)

	# handle dash
	if dash_cd > 0:
		dash_cd -= delta
		if dash_cd < dash_stun_threshold and !has_dashed:
			# handle dash
			# currently we just teleport through walls and stuff, fun ik
			# TODO rewrite into a function in the future
			
			# direction does not change unless we alter inputs
			# we wont do that while dashing
			position.x += 48 * direction
			velocity.y = JUMP_HEIGHT
			velocity.x = MAX_SPEED * direction
			has_dashed = true
	elif dash_cd <= 0:
		# catch overshoot, like negative cd
		# might help in the future idk
		dash_cd = 0
		has_dashed = false

	# where we put everything affecting input together
	# its just gonna be one big AND statement
	# TODO: when we add grapple, consider adding it here as well
	
	# first statement: 
	#	  player has pressed dash AND alredy executed dash
	#  or player has not even touched the button
	can_input = (has_dashed or dash_cd <= 0)
	
	# gravity
	if not is_on_floor():
		# if not in the brief stun period just before you begin your dash: can be optimized by logic probably
		if !(!has_dashed and dash_cd > 0): # player not dashed, but has pressed dash
			velocity += get_gravity() * delta
		airtime += delta
	else: 
		# reusing if/else statements
		# if on the floor, reset jump count
		air_jumps_left = 1 # if you gently touch the floor it also resets
		airtime = 0
	
	# handle inputs
	if can_input:
		direction = 0 # for later
		# handle jump, might warrant refactoring in the future when i add jump animations
		
		# initiate jump sequence
		if Input.is_action_just_pressed("jump"):
			if airtime <= 0.05:
				velocity.y = JUMP_HEIGHT
			elif air_jumps_left > 0:
				velocity.y = JUMP_HEIGHT
				air_jumps_left -= 1

		# Get the input direction and handle the movement/deceleration.
		direction = Input.get_axis("left","right")
		if direction:
			velocity.x += direction * ACCEL * delta * 60
			# caps player speed
			if abs(velocity.x) > MAX_SPEED:
				velocity.x = MAX_SPEED * sign(velocity.x)
			
			# flip sprite based on direction
			if direction > 0:
				sprite.flip_h = false
			elif direction < 0:
				sprite.flip_h = true
			# if direction = 0, dont change anything
		else:
			velocity.x *= 0.8
			
		# here we override the x velocity (we just set it)
		if Input.is_action_just_pressed("dash") and dash_cd <= 0:
			 # stop moving for a sec
			velocity.x = 0
			velocity.y = 0
			# automatically sets can_input
			dash_cd = 0.5
	
	# reset button
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
	# physics
	move_and_slide()
	
	
	# attacking time
	# move sword
	if direction > 0:
		sword.position = Vector2(8,0)
	elif direction < 0:
		sword.position = Vector2(-8,0)
	# swing sword cuz cool
	if Input.is_action_just_pressed("attack"):
		sword.swing(delta,sprite.flip_h)

func take_damage(damage:float,from_position:Vector2):
	# die check goes here
	health -= damage
	
	if health <= 0:
		call_deferred("restart")

	
	var magnitude = damage * 2
	# repel
	var vect:Vector2 = from_position - global_position
	velocity = -vect * magnitude
	
	air_jumps_left = 1

func restart():
	get_tree().reload_current_scene()
