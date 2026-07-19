extends Node2D

enum Enemies {NORMAL,SHOOTER}

var ENEMY_SCENES: Dictionary[int,Resource] = {
	Enemies.NORMAL:preload("res://scenes/enemies/enemy.tscn"),
	Enemies.SHOOTER:preload("res://scenes/enemies/shooter.tscn")
}


var random = RandomNumberGenerator.new()

func spawn_enemy(type):
	spawn_cd = 5
	var enemy: Enemy = ENEMY_SCENES[type].instantiate()
	enemy.global_transform = global_transform
	get_parent().add_child(enemy)
	enemy.direction = (random.randi_range(0,1)-0.5)*2
	#enemy.velocity.x = enemy.MAX_SPEED * enemy.direction
	enemy.velocity.y = enemy.JUMP_HEIGHT

var spawn_cd = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_cd > 0:
		spawn_cd -= delta
	else:
		spawn_cd = 0
		spawn_enemy(Enemies.NORMAL)
	
