class_name Bullet
extends Node2D

var parry_particle = preload("res://scenes/particles/parry_particle.tscn")

var damage:float
var speed = 150
var lifetime = 10


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
	if body is Player:
		body.take_damage(10,global_position)
		destroy()
	else:
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Sword:
		destroy()
		
func destroy() -> void:
	var p:GPUParticles2D = parry_particle.instantiate()
	p.global_position = global_position
	p.name = "ParryParticle"
	p.restart()
	
	get_tree().get_first_node_in_group("game").get_child(1).add_child(p) # fix the index if something breaks
	queue_free()
	
