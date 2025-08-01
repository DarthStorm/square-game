class_name Enemy
extends CharacterBody2D
# this is a basic enemy thingy
# basic ai
# so can copy and paste for later use

# constants that determine enemy movement basics
const ACCEL = 20
const JUMP_HEIGHT = -300
const MAX_SPEED = 170

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D # texture
# coyote time
var airtime = 999

# pve things
var health = 100
var damage = 5 # collision damage

# movement
# general prep
var can_input = false
var direction = 0

func _physics_process(delta: float) -> void:
	# tick regardless of input

	# tick down some cds
	# remember: delta is approx 1/60, so between 0 and 1
	# so any cds are all in seconds (set cd to 1 = cd is 1 second)

	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		airtime += delta
	else: 
		# reusing if/else statements
		# if on the floor, reset jump count
		airtime = 0
	
	# handle inputs
	if can_input:
		direction = 0 # for later
		# handle jump, might warrant refactoring in the future when i add jump animations
		
		# initiate jump sequence
		if Input.is_action_just_pressed("jump"):
			if airtime <= 0.05:
				velocity.y = JUMP_HEIGHT

		# Get the input direction and handle the movement/deceleration.
		direction = Input.get_axis("left","right")
		if direction:
			velocity.x += direction * ACCEL * delta * 60
			# caps player speed

	velocity.x *= 0.8
	if abs(velocity.x) > MAX_SPEED:
		velocity.x = MAX_SPEED * sign(velocity.x)
	# flip sprite based on direction
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	# if direction = 0, dont change anything
	
	# physics
	move_and_slide()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage(damage,global_position)

func take_damage(dmg:float,from_position:Vector2,kbup:bool=false):
	# die check goes here
	health -= dmg
	
	if health <= 0:
		pass # die!
	
	var magnitude = dmg * 2
	# repel
	var vect:Vector2 = from_position - global_position
	if kbup:
		vect.y -= 1000
	velocity = -vect * magnitude
