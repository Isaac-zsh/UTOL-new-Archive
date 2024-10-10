extends Node

var debug = true

func _input(event):
	if debug:
		if event is InputEventKey and event.pressed:
			if event.scancode == KEY_P:
				if event.shift:
					Scene.switch(int(get_tree().get_current_scene().get_name())+1)
			elif event.scancode == KEY_O:
				if event.shift:
					Scene.switch(int(get_tree().get_current_scene().get_name())-1)
