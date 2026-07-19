extends TextureButton

var pausebutton:TextureButton
var exitbutton:TextureButton


func _on_ready() -> void:
	pausebutton = $"../Pause"
	exitbutton = $"../Exit"
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_pressed() -> void:
	# switch to pause button
	hide()
	pausebutton.show()
	exitbutton.hide()
	get_tree().paused = false
	accept_event()
