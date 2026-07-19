class_name Enemy
extends CharacterBody2D
# this is a basic enemy thingy
# basic ai
# so can copy and paste for later use

# constants that determine enemy movement basics
const ACCEL = 20
const JUMP_HEIGHT = -300
const MAX_SPEED = 170 * 0.6

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D # texture
@onready var health_bar: HealthBar = $HealthBar

@onready var raycast_tl: RayCast2D = $RayCastTopLeft
@onready var raycast_tr: RayCast2D = $RayCastTopRight
@onready var raycast_bl: RayCast2D = $RayCastBottomLeft
@onready var raycast_br: RayCast2D = $RayCastBottomRight

var coin_scene = preload("res://scenes/collectibles/coin.tscn") # summon on death


# coyote time
var airtime = 999

# pve things
var max_health = 100
var health = max_health
var damage = 5 # collision damage

# movement
# general prep
var can_input = true
var can_move = true
var stun_timer = 0
var direction = 1

func _ready() -> void:
	health_bar.init(health)
	health_bar.update(health)

# methods of default enemy
func handle_stun_timer(delta:float) -> void:
	"""Ticks down the stun timer of the enemy."""
	if stun_timer > 0:
		stun_timer -= delta
		if stun_timer < 0.2:
			can_input = true
			stun_timer = 0
		else:
			can_input = false
	elif stun_timer <= 0:
		# catch overshoot, like negative cd
		# might help in the future idk
		stun_timer = 0
		can_input = true
		
func handle_gravity(delta:float) -> void:
	"""Increments gravity."""
	if not is_on_floor():
		velocity += get_gravity() * delta
		airtime += delta
	else: 
		# reusing if/else statements
		# if on the floor, reset jump count
		airtime = 0

func handle_turning():
	"""Turns the enemy when it is about to hit a wall."""
	if not((raycast_tr.is_colliding() or raycast_br.is_colliding()) and (raycast_tl.is_colliding() or raycast_bl.is_colliding())):
		if raycast_tr.is_colliding() or raycast_br.is_colliding():
			direction = -1 # turn left
		elif raycast_tl.is_colliding() or raycast_bl.is_colliding():
			direction = 1 # turn right
		
func move_lr(delta:float) -> void:
	"""Moves in a direction."""
	if direction:
		velocity.x += direction * ACCEL * delta * 60

func handle_velocity(delta:float) -> void:
	"""Handles air resistance and caps the velocity."""
	if is_on_floor():
		velocity.x *= 0.8 ** delta
	else:
		velocity.x *= 0.9 ** delta
	if abs(velocity.x) > MAX_SPEED:
		velocity.x = MAX_SPEED * sign(velocity.x)
		
func handle_sprite():
	"""Flips sprite based on direction."""
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

func jump():
	"Makes the enemy jump."
	velocity.y = JUMP_HEIGHT
	velocity.x = direction * MAX_SPEED * 10

func move(delta:float) -> void:
	"""Moves the enemy."""
	handle_gravity(delta)
	if can_input:
		handle_turning()
		move_lr(delta)
	handle_velocity(delta)
	handle_sprite()
	move_and_slide()

func _physics_process(delta: float) -> void:
	handle_stun_timer(delta)
	move(delta)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage,global_position)

func take_damage(dmg:float,from_position:Vector2,kbup:bool=false):
	# die check goes here
	health -= dmg	
	health_bar.update(health)
	
	if health <= 0:
		kill()
	
	var magnitude = dmg * 2
	# repel
	var vect:Vector2 = from_position - global_position
	if kbup:
		vect.y = -JUMP_HEIGHT / magnitude / 1.5
	velocity = -vect * magnitude
	
	stun_timer = 0.6

func kill():
	# die
	var coin:Coin = coin_scene.instantiate()
	get_parent().call_deferred("add_child", coin) # avoid conflicts with physics engine
	coin.global_position = global_position
	
	coin.from_enemy = true
	
	queue_free()
