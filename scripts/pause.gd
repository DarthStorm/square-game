extends TextureButton

var playbutton:TextureButton
var exitbutton:TextureButton

func _on_ready() -> void:
	playbutton = $"../Play"
	exitbutton = $"../Exit"
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _on_pressed() -> void:
	# switch to play button
	hide()
	playbutton.show()
	exitbutton.show()
	
	# pause...
	get_tree().paused = true
	
	# stop from clicking sword
	accept_event()
