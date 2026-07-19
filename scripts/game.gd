extends Node2D

@onready var ui = $UI

func _on_ready() -> void:
	var level = GameData.selected_level.instantiate()
	add_child(level)
	move_child(ui,2)
