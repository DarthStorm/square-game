extends Node

var selected_level:PackedScene

func select_level(fp:String):
	selected_level = load(fp)
	get_tree().change_scene_to_file("res://scenes/game.tscn")
