class_name Player
extends CharacterBody2D
# hi guys
# constants that determine player movement basics
const ACCEL = 20
const JUMP_HEIGHT = -300
const MAX_SPEED = 200

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D # texture
@onready var sword: Sword = $Sword
@onready var healthbar: HealthBar = $HealthBar
@onready var coordsdisplay: Label = $CoordsDisplay

var playerbullet_scene = preload("res://scenes/player/playerbullet.tscn")

# debug
var show_coords = true

var ui_healthbar: HealthBar
var ui_coindisplay: CoinDisplay
# pve things
var max_health = 100
var health = max_health

# dash

# left/right enum


# attack
var primary_attack_speed = 0.2 # is var cuz will likely change
var primary_attack_timer = 0

var secondary_attack_speed = 0.3 # is var cuz will likely change
var secondary_attack_timer = 0

# skill
var skill_1_cd = 3
var skill_1_timer = 0

# double jump
var air_jumps_left = 0
var max_air_jumps = 1
# coyote time
var airtime = 999

# money
var coins = 0


# general prep
var can_input = true
var direction = 0
var axis = 0

func _ready() -> void:
	healthbar.init(max_health)
	ui_healthbar = get_tree().get_nodes_in_group("healthbar")[0] # check this if something breaks
	ui_healthbar.update(max_health)
	ui_coindisplay = get_tree().get_nodes_in_group("coindisplay")[0]
	ui_coindisplay.init(coins) # interesting

func shoot() -> PlayerBullet:
	var bullet:PlayerBullet = playerbullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.name = "PlayerBullet"
	bullet.global_position = global_position
	bullet.global_rotation = (direction - 1) * PI / 2 # factorization
	bullet.damage = 25
	
	return bullet
	

func _physics_process(delta: float) -> void:
	# tick regardless of input
	
	# tick down cds
	primary_attack_timer = move_toward(primary_attack_timer,0,delta) # wont go past 0 so cool
	secondary_attack_timer = move_toward(secondary_attack_timer,0,delta)
	skill_1_timer = move_toward(skill_1_timer,0,delta)
	
	can_input = true
	
	# gravity
	if not is_on_floor(): # if in air
		velocity += get_gravity() * delta
		airtime += delta
	else:
		# reusing if/else statements
		# if on the floor, reset jump count
		air_jumps_left = max_air_jumps # if you gently touch the floor it also resets
		airtime = 0
	
	# handle inputs
	if can_input:
		# handle jump, might warrant refactoring in the future when i add jump animations
		
		# initiate jump sequence
		if Input.is_action_just_pressed("jump"):
			if airtime <= 0.05:
				velocity.y = JUMP_HEIGHT
			elif air_jumps_left > 0:
				velocity.y = JUMP_HEIGHT
				air_jumps_left -= 1

		# Get the input direction and handle the movement/deceleration.
		axis = Input.get_axis("left","right")
		if axis:
			
			velocity.x += axis * ACCEL * delta * 60
			# caps player speed
			if abs(velocity.x) > MAX_SPEED:
				velocity.x = MAX_SPEED * sign(velocity.x)
				
			# disable looking left and right if animation is playing
			if primary_attack_timer <= 0:
				direction = axis
		else:
			if is_on_floor():
				velocity.x *= 0.8
			else:
				velocity.x *= 0.9
			
		# here we override the x velocity (we just set it)
		if Input.is_action_just_pressed("skill_1") and skill_1_timer <= 0:
			pass
	
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
	if Input.is_action_just_pressed("attack") and primary_attack_timer <= 0:
		primary_attack_timer = primary_attack_speed
		if false:
			sword.swing(delta,sign(get_local_mouse_position().x))
			direction = sign(get_local_mouse_position().x)
		else:
			sword.swing(delta,direction)
			
	if Input.is_action_pressed("attack2") and secondary_attack_timer <= 0:
		secondary_attack_timer = secondary_attack_speed
		shoot()
		# when you mod the game a 		#for i in range(9):
			#var x = shoot()
			#x.global_position += Vector2(0, (i-5) * 5)
			#x.rotate((i-5) / PI / 2 * direction)bit TOO much

			
	# spriting time
	# flip sprite based on direction
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	# if direction = 0, dont change anything
	
	
	# debug
	if show_coords:
		coordsdisplay.text = "(" + str(round(global_position.x)) +"," + str(round(global_position.y)) + ")"
	
func take_damage(damage:float,from_position:Vector2):
	# die check goes here
	health -= damage
	
	healthbar.update(health)
	ui_healthbar.update(health)
	if health <= 0:
		kill()

	
	var magnitude = damage * 2
	# repel
	var vect:Vector2 = from_position - global_position
	velocity = -vect * magnitude
	
	air_jumps_left = 1
	
func get_coins(num_coins:int) -> void:
	# when player gets some coins
	coins += num_coins
	# update coin bar
	ui_coindisplay.update(coins)
	

func kill():
	health = 0
	call_deferred("restart")

func restart():
	if get_tree():
		get_tree().reload_current_scene()
	else:
		print("tree cannot be acquired TwT")
