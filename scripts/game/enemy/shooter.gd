class_name Shooter
extends Enemy

var bullet_scene = preload("res://scenes/enemies/bullet.tscn")


var shooting = false
var shoot_cd = 0

func _init() -> void:
	health = 50

func handle_shoot_cd(delta:float) -> void:
	if shoot_cd > 0:
		shoot_cd -= delta
	else:
		shoot_cd= 0

func shoot() -> void:
	shoot_cd = 1
	sprite.play("shoot")
	var bullet:Bullet = bullet_scene.instantiate()
	bullet.damage = 10
	get_parent().add_child(bullet)
	bullet.name = "Bullet"
	bullet.global_position = global_position
	
	var player = get_tree().get_nodes_in_group("player")[0]
	
	var v = player.global_position - global_position
	bullet.rotation = v.angle()
	
func can_shoot() -> bool:
	var player:Player = get_tree().get_nodes_in_group("player")[0]
	
	var target_distance:float = (player.global_position - global_position).length()
	
	return (shoot_cd <= 0) and (target_distance < 8 * 16)

func _physics_process(delta: float) -> void:
	handle_stun_timer(delta)
	handle_shoot_cd(delta)
	move(delta)
	
	if can_shoot():
		shoot()
