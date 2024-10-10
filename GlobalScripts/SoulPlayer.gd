extends Node2D

var mode = 0
var selected_choice_h = 1
var selected_choice_w = 1
var select_limit_h = 0
var select_limit_w = 0
var soulside = 1

func activate(soul_mode):
	mode = soul_mode
	pass

func sprite(num):
	$Soul.play(str(num))
	pass

func _move_interact(v):
	Borders.soul_interact = v
	pass

func _process(_delta):
	if mode == 1:
		if selected_choice_h < 1:
			selected_choice_h = select_limit_h
			get_owner()._move_soul()
		elif selected_choice_h > select_limit_h:
			selected_choice_h = 1
			get_owner()._move_soul()
	elif mode == 2:
		if selected_choice_w < 1:
			selected_choice_w = select_limit_w
			get_owner()._move_soul()
		elif selected_choice_w > select_limit_w:
			selected_choice_w = 1
			get_owner()._move_soul()
	pass

func _input(_event):
	if Borders.soul_interact:
		if mode == 1:
			if Input.is_action_just_pressed("Down"):
				Audio.sfx(0, 0)
				if selected_choice_h < select_limit_h:
					selected_choice_h += 1
				else:
					selected_choice_h = 1
				get_owner()._move_soul()
			elif Input.is_action_just_pressed("Up"):
				Audio.sfx(0, 0)
				if selected_choice_h != 1:
					selected_choice_h -= 1
				else:
					selected_choice_h = select_limit_h
				get_owner()._move_soul()
			if Input.is_action_just_pressed("Accept"):
				if Borders.soul_interact:
					Audio.sfx(1, 0)
					get_owner().soul_option()
			elif Input.is_action_just_pressed("Return"):
				if Borders.soul_interact:
					Audio.sfx(0, 0)
					get_owner().soul_return()
		elif mode == 2:
			if Input.is_action_just_pressed("Right"):
				Audio.sfx(0, 0)
				if selected_choice_w < select_limit_w:
					selected_choice_w += 1
				else:
					selected_choice_w = 1
				get_owner()._move_soul()
			elif Input.is_action_just_pressed("Left"):
				Audio.sfx(0, 0)
				if selected_choice_w != 1:
					selected_choice_w -= 1
				else:
					selected_choice_w = select_limit_w
				get_owner()._move_soul()
			if Input.is_action_just_pressed("Accept"):
				if Borders.soul_interact:
					Audio.sfx(1, 0)
					get_owner().soul_option()
			elif Input.is_action_just_pressed("Return"):
				if Borders.soul_interact:
					Audio.sfx(0, 0)
					get_owner().soul_return()
	pass
