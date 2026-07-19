extends TextureButton



func _on_ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()

func _on_pressed() -> void:
	# switch to play button
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
