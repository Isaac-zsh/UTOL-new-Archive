extends Node2D

var slot = 1
var dots = ""
var status = "Authenticating"
var file = File.new()
var dir = Directory.new()
var slot_exist = {
	"slot1": false,
	"slot2": false,
	"slot3": false
}
var userdata = {
	"username1": "",
	"username2": "",
	"username3": "",
	"token1": "",
	"token2": "",
	"token3": ""
}
var selected_slot = 0
var once = true
var once3 = false
onready var Soul = $Layer2/UI/SoulPlayer
onready var movesoul = get_node("MoveSoul")

func _ready():
	$Layer2/UI/CheckUserData.hide()
	_move_()
	_result(0)
	Soul.select_limit_h = 3
	Soul.select_limit_w = 2
	Soul.activate(1)
	Borders.fade(-2)
	pass

func _process(_delta):
	$Layer2/UI/CheckUserData.text = status + dots
	if GJKeys._logged_in:
		if GJKeys.once2 == false:
			_result(2)
			GameJolt._logout()
			GJKeys._logged_in = false
	if GJKeys.once2 == false:
		_status(GJKeys.istatus)
		GJKeys.istatus += 1
		GJKeys.once2 = true
	if slot_exist["slot1"] == true and slot_exist["slot2"] == true and slot_exist["slot3"] == true:
		$Layer2/UI/SlotsFullPanel.show()
	else:
		$Layer2/UI/SlotsFullPanel.hide()
	_check_slots()
	if has_node("Layer2/UI/s_"+str(Soul.selected_choice_h)):
		if Soul.mode == 0:
			Soul.position = get_node("Layer2/UI/s_"+str(Soul.selected_choice_h)).rect_position + Vector2(-16,10)
		if Soul.sideselect == 1:
			_color_all_white("s")
			get_node("Layer2/UI/s_"+str(Soul.selected_choice_h)).modulate = Color8(255,255,0)
		elif Soul.sideselect == 2:
			_color_all_white("b")
			get_node("Layer2/UI/b_"+str(Soul.selected_choice_h)).modulate = Color8(255,255,0)
	if has_node("Layer2/UI/o_"+str(Soul.selected_choice_w)):
		if Soul.sideselect == 3:
			_color_all_white("o")
			get_node("Layer2/UI/o_"+str(Soul.selected_choice_w)).modulate = Color8(255,255,0)
	pass

func _check_slots():
	if slot < 4:
		if file.file_exists("user://acc_s"+str(slot)+".dat"):
			file.open_encrypted_with_pass("user://acc_s"+str(slot)+".dat", File.READ, GJKeys.encryption_key)
			userdata["username"+str(slot)] = file.get_line()
			userdata["token"+str(slot)] = file.get_line()
			slot_exist["slot"+str(slot)] = true
			file.close()
			get_node("Layer2/UI/s_"+str(slot)+"/Username").text = userdata["username"+str(slot)]
			if selected_slot == slot:
				if Soul.sideselect == 2:
					soul_return()
		else:
			slot_exist["slot"+str(slot)] = false
			get_node("Layer2/UI/s_"+str(slot)+"/Username").text = "?"
			if selected_slot == slot:
				if Soul.sideselect == 3:
					soul_return()
	pass

func _color_all_white(t):
	get_node("Layer2/UI/"+t+"_1").modulate = Color8(255,255,255)
	get_node("Layer2/UI/"+t+"_2").modulate = Color8(255,255,255)
	if has_node("Layer2/UI/"+t+"_3"):
		get_node("Layer2/UI/"+t+"_3").modulate = Color8(255,255,255)
	pass

func _return_stuff(n):
	GameJolt._logout()
	GJKeys.once2 = false
	GJKeys.istatus = 0
	$Layer2/UI/FriskLoading/Walk.play_backwards("Walk1")
	$Layer2/UI/MoveAllUp.play_backwards("MoveUp")
	once3 = true
	_stop_dots()
	$Layer2/UI/CheckUserData.modulate = Color8(255, 0, 0)
	if n == 1:
		status = "Failed to connect!"
	elif n == 2:
		status = "Failed to authenticate!"
		pass

func _authenticate():
	once = false
	_result(1)
	_disable_input_boxes()
	GameJolt._login($Layer2/UI/b_1.text, $Layer2/UI/b_2.text, selected_slot)
	pass

func _move_():
	if Soul.sideselect == 1:
		if has_node("Layer2/UI/s_"+str(Soul.selected_choice_h)):
			var pos = get_node("Layer2/UI/s_"+str(Soul.selected_choice_h)).rect_position + Vector2(-20,64)
			movesoul.interpolate_property(Soul, "position",
			Soul.position, pos, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			movesoul.start()
	elif Soul.sideselect == 2:
		if has_node("Layer2/UI/b_"+str(Soul.selected_choice_h)):
			if Soul.selected_choice_h == 1:
				get_node("Layer2/UI/b_1").grab_focus()
				get_node("Layer2/UI/b_1").set_editable(true)
				get_node("Layer2/UI/b_2").release_focus()
				get_node("Layer2/UI/b_2").set_editable(false)
			elif Soul.selected_choice_h == 2:
				get_node("Layer2/UI/b_2").grab_focus()
				get_node("Layer2/UI/b_2").set_editable(true)
				get_node("Layer2/UI/b_1").release_focus()
				get_node("Layer2/UI/b_1").set_editable(false)
			elif Soul.selected_choice_h == 3:
				_disable_input_boxes()
			var pos = get_node("Layer2/UI/b_"+str(Soul.selected_choice_h)).rect_position + Vector2(-20,10)
			movesoul.interpolate_property(Soul, "position",
			Soul.position, pos, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			movesoul.start()
	elif Soul.sideselect == 3:
		if has_node("Layer2/UI/o_"+str(Soul.selected_choice_w)):
			var pos = get_node("Layer2/UI/o_"+str(Soul.selected_choice_w)).rect_position + Vector2(-16.5,7.5)
			movesoul.interpolate_property(Soul, "position",
			Soul.position, pos, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			movesoul.start()
	pass

func _disable_input_boxes():
	get_node("Layer2/UI/b_1").release_focus()
	get_node("Layer2/UI/b_1").set_editable(false)
	get_node("Layer2/UI/b_2").release_focus()
	get_node("Layer2/UI/b_2").set_editable(false)
	pass

func _move_soul():
	_move_()
	pass

func soul_option():
	if Soul.sideselect == 1:
		selected_slot = Soul.selected_choice_h
		if slot_exist["slot"+str(selected_slot)] == false:
			Soul.selected_choice_h = 1
			Soul.sideselect = 2
			_color_all_white("s")
			_move_()
		elif slot_exist["slot"+str(selected_slot)] == true:
			Soul.selected_choice_h = 1
			Soul.sideselect = 3
			_color_all_white("s")
			_color_all_white("b")
			_color_all_white("o")
			Soul.activate(2)
			_move_()
	elif Soul.sideselect == 2:
		if Borders.clickable:
			Borders.clickable = false
			if Soul.selected_choice_h == 3:
				_authenticate()
	elif Soul.sideselect == 3:
		if Soul.selected_choice_w == 1:
			_start_authenticate()
			#$Layer2/UI/MoveAllUp.play("MoveUp")
		elif Soul.selected_choice_w == 2:
			_delete_account(selected_slot)
	pass

func _start_authenticate():
	$Layer2/UI/MoveAllUp.play("MoveUp")
	pass

func _result(type):
	if type == 0:
		$Layer2/UI/b_3/change_text.play("Auth")
	elif type == 1:
		$Layer2/UI/b_3/change_text.play("Authenticating")
	elif type == 2:
		$Layer2/UI/b_3/change_text.play("Authenticated")

func _delete_account(slot):
	if file.file_exists("user://acc_s"+str(slot)+".dat"):
		dir.remove("user://acc_s"+str(slot)+".dat")
	pass

func soul_return():
	if Soul.sideselect == 2:
		Soul.selected_choice_h = selected_slot
		Soul.sideselect = 1
		$Layer2/UI/b_1.text = ""
		$Layer2/UI/b_2.text = ""
		_disable_input_boxes()
		_color_all_white("b")
		_move_()
	elif Soul.sideselect == 3:
		Soul.selected_choice_w = 1
		Soul.selected_choice_h = selected_slot
		Soul.sideselect = 1
		_color_all_white("o")
		$Layer2/UI/o_1.modulate = Color8(150,150,150)
		$Layer2/UI/o_2.modulate = Color8(150,150,150)
		Soul.activate(1)
		_move_()
	pass

func _on_CheckFiles_timeout():
	if slot < 4:
		slot += 1
	else:
		slot = 1
	pass # Replace with function body.

func _on_change_text_animation_finished(anim_name):
	if anim_name == "Authenticated":
		_result(0)
		GJKeys._logged_in = false
	pass # Replace with function body.

func _on_change_text_animation_started(anim_name):
	if anim_name == "Authenticated":
		if once == false:
			Audio.sfx(2, 0)
			once = true
	pass # Replace with function body.

func _on_dots_timeout():
	if dots != "...":
		dots += "."
	else:
		dots = ""
	pass # Replace with function body.

func _status(num):
	if num == 0:
		status = "Authenticating"
		GameJolt._login(userdata["username"+str(selected_slot)], userdata["token"+str(selected_slot)], selected_slot)
	elif num == 1:
		status = "Fetching User Data" + "\n" + "Gold"
		GameJolt.fetch_data("gold", false, GJKeys.istatus)
	elif num == 2:
		status = "Fetching User Data" + "\n" + "Skin"
		GameJolt.fetch_data("skin", false, GJKeys.istatus)
	elif num == 3:
		status = "Fetching User Data" + "\n" + "HP"
		GameJolt.fetch_data("hp", false, GJKeys.istatus)
	elif num == 4:
		status = "Connecting to Server"
		Server._connect_server()
	elif num == -1:
		_stop_dots()
		$Layer2/UI/MoveAllUp.play("MoveUp2")
		$Layer2/UI/FriskLoading/Walk.play("Walk2")
		status = "Connected!"
		Audio.sfx(2,0)
	pass

func _stop_dots():
	dots = ""
	$Layer2/UI/dots.stop()
	dots = ""
	pass

func _on_MoveAllUp_animation_finished(anim_name):
	if anim_name == "MoveUp":
		if once3 == false:
			GJKeys.once2 = false
			_status(GJKeys.istatus)
			$Layer2/UI/dots.start()
			$Layer2/UI/FriskLoading/Walk.play("Walk1")
			$Layer2/UI/FriskLoading.play("Walk1")
			once3 = true
	elif anim_name == "MoveUp2":
		Borders.fade(4)
		pass
	pass # Replace with function body.
