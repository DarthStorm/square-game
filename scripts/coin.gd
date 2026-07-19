class_name Coin
extends Area2D

@onready var enemytimer = $EnemyTimer

# -1 -> not activated, 0 -> activated but not moving, +ve -> moving
const ACCEL = 320

var from_enemy = false
var speed = -1

var velocity:Vector2 = Vector2(0,0)
var target_player:Player

func _on_body_entered(player: Node2D) -> void:
	if player is Player:
		# collect coin!
		player.get_coins(1)
		# add special effects later, delete coin for now
		queue_free()

func _ready() -> void:
	if from_enemy:
		init_from_enemy()

func init_from_enemy() -> void:
	# start timer and stuff, coin will fly towards the player
	enemytimer.start()
	
func get_closest_player(radius:float = 9999999): # -> Player or null
	var radius_squared = radius * radius # square the radius
	var players = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		print("No players...")
		return null
	if len(players) == 1:
		if global_position.distance_squared_to(players[0].global_position) < radius_squared:
			return players[0]
		else:
			print("No player in range...")
			return null
	else:
		# nearest player
		var closest_distance = radius_squared + 1 # can be literally any number
		var closest_player:Player = null # kinda illegal
		var dist: float
		for player in players:
			dist = global_position.distance_squared_to(player.global_position)
			if dist < closest_distance:
				closest_distance = dist
				closest_player = player
				
		if closest_distance < radius_squared:
			return closest_player
		else:
			print("No players within distance")
			return null
			
			

func _physics_process(delta:float) -> void:
	if speed >= 0:
		speed += delta * ACCEL
	target_player = get_closest_player() # -> can return null, handle it
	if target_player:
		velocity = (target_player.global_position - global_position).normalized() * speed
		# if collision is needed, switch to CharacterBody2D instead of Area2D
		# and call move_and_slide()
		global_position += velocity * delta
	else:
		speed = 0
		velocity = Vector2.ZERO
	
	
	

func _on_enemy_timer_timeout() -> void:
	# fly towards player
	speed = 0
