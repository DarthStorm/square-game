extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

"""
extends CharacterBody2D
# hi guys

# player movement:
# coyote time
# jump
# dash - with cd ofc
# - i rlly liked how slash had a little jump every slash, want to implement that in as well
# - just add y velocity by a bit
# DOUBLE JUMP: total jump times = 2, minus 1 every jump, dont allow jumping if jump times at 0
# grapple = idk how to implement this

# so anyway i did copy and paste

const ACCEL = 130
const JUMP_HEIGHT = -400


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# adding coyote time
var airtime = 999
# multi jump
var jumps_left = 2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# handle jump
	airtime += delta * 60
	# Handle jump.
	if is_on_floor():
		airtime = 0
		
	var direction = 0 # for later
	
	if Input.is_action_just_pressed("jump"):
		if airtime < 10:
			# initiate jump sequence
			velocity.y = JUMP_HEIGHT
			airtime = 999
			jumps_left -= 1
		elif jumps_left > 0:
			# initiate jump sequence
			velocity.y = JUMP_HEIGHT
			airtime = 999
			jumps_left -= 1
			

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("left","right")
	if direction:
		velocity.x += direction * ACCEL * delta * 60
		
		# flip sprite based on direction
		if direction > 0:
			sprite.flip_h = false
		elif direction < 0:
			sprite.flip_h = true
		# if direction = 0, dont change anything
	else:
		velocity.x = move_toward(velocity.x, 0, 130)

	move_and_slide()

"""
