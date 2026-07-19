extends Button

# change this variable later
@export var level: int

var level_name:String
# on click -> start scene
func _on_pressed() -> void:
	level_name = LevelRef.levels.get(level, "level1")
	GameData.select_level("res://scenes/levels/%s.tscn" % level_name)
