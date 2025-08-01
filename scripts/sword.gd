class_name Sword
extends Node2D

@onready var animplayer = $AnimationPlayer
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func swing(_delta:float,left:bool) -> void:
	if left:
		animplayer.play("swing_left")
	else:
		animplayer.play("swing_right")
	pass

func _on_hurtbox_body_entered(enemy: Node2D) -> void:
	if enemy is Enemy:
		enemy.take_damage(5,global_position,true)
