class_name HealthBar
extends Control

@onready var healthbar = $ProgressBar
@onready var healthdisplay = $ProgressBar/HealthDisplay
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init(val:float):
	healthbar.max_value = val
	healthdisplay.text = str(int(val))

func update(val:float) -> void:
	healthbar.value = val
	healthdisplay.text = str(int(val))
	
