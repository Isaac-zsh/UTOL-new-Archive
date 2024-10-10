extends Node2D

func sfx(num, mode):
	if mode == 0:
		get_node("sfx"+str(num)).play()
	else:
		get_node("sfx"+str(num)).stop()
	pass

func music(num, mode):
	if mode == 0:
		get_node("music"+str(num)).play()
	else:
		get_node("music"+str(num)).stop()
	pass
