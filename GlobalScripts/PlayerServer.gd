extends Node2D

func MovePlayer(new_position):
	set_position(new_position)
	pass

func SetAnim(Name, Frame):
	$Player.set_animation(Name)
	$Player.set_frame(Frame)

func SetName(Name):
	$Username.text = Name
