extends Button

# on click -> start scene

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")
