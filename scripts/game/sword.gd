class_name Sword
extends Node2D

@onready var animplayer:AnimationPlayer = $AnimationPlayer
@onready var sprite:Sprite2D = $Sprite2D
@onready var hurtbox:Area2D = $Hurtbox
@onready var timer:Timer = $Timer

var anim_time = 0.2

var sword_damage = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = 0.2
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func swing(_delta:float,direction:float) -> void:
	hurtbox.monitorable = true
	hurtbox.monitoring = true
	if direction < 0:
		animplayer.play("swing_left")
	else:
		animplayer.play("swing_right")
	timer.start()



func _on_hurtbox_body_entered(enemy: Node2D) -> void:
	if enemy is Enemy:
		enemy.take_damage(20,global_position,true)


func _on_timer_timeout() -> void:
	hurtbox.monitorable = false
	hurtbox.monitoring = false
