class_name PlayerBullet
extends Node2D

var playerbullet_particle = preload("res://scenes/particles/playerbullet_particle.tscn")

var damage:float
var speed = 500
var lifetime = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Enemy:
		pass # bad coding
	else:
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Enemy or parent is Shooter: # ensures we hit the hitbox and not the collision of enemy (hitbox smaller)
		# godot needs a better way
		# hmmmmmm
		parent.take_damage(damage,global_position)
		destroy()
		
func destroy() -> void:
	var p:GPUParticles2D = playerbullet_particle.instantiate()	
	get_tree().get_first_node_in_group("game").get_child(0).add_child(p) # fix the index if something breaks
	p.global_position = global_position # set position after assignment to parent	
	p.name = "ParryParticle"
	p.restart()
	
	print(global_position)
	queue_free()
	
