extends Node

var sword_level = 1;

# weirdest syntax ever
# i see why people use braces (i now like them)
# not semicolons tho
# like why do they even exist—

var upgrades = {
	"sword_lvl_2" : func():
		sword_level = 2,
	"sword_lvl_3" : func():
		sword_level = 4
		print("hi"),
}

func call_upgrade(upgrade_string: String):
	var function = upgrades.get(upgrade_string)
	if function:
		function.call();
	else:
		print("Invalid upgrade string %s1: %s2" % [upgrade_string, get_script().get_path()])

func _ready() -> void:
	pass
