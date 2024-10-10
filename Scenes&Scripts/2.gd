extends Node2D

onready var soul = $Layer2/UI/SoulPlayer
onready var movesoul = get_node("MoveSoul")
var account_check = 1
var selected_account = 1
var file = File.new()
var dir = Directory.new()
var dots = ""
var fetch_status = ""
var auth_s = 1
var anim_type = 0
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

func _ready():
	soul.position = $Layer2/UI/account_1.rect_position + Vector2(-20,64)
	auth_s = -1
	_set_color()
	soul.activate(1)
	Borders.fade(-2, "")
	pass

func _process(_delta):
	_set_fetch_status()
	_change_auth()
	_set_limits()
	_check_accounts()
	_sync_accounts()
	_enable_input()
	pass

func _auth_failed():
	anim_type = 1
	fetch_status = "Failed!"
	GameJolt._logout()
	Borders.fade(-1, "Failed!")
	$Layer2/UI/MoveAllUp.get_animation("MoveUp").track_set_key_value(12, 1, Color8(255, 0, 0))
	$Layer2/UI/FriskLoading/Walk.play_backwards("Walk1")
	$Layer2/UI/MoveAllUp.play_backwards("MoveUp")
	$Layer2/UI/CheckUserData.modulate = Color8(255, 0, 0)
	pass

func end_auth():
	$Layer2/UI/FriskLoading/Walk.play("Walk2")
	$Layer2/UI/MoveAllUp.play("MoveUp2")
	fetch_status = "Success!"
	Audio.sfx(2, 0)
	pass

func _set_fetch_status():
	if fetch_status != "" and fetch_status != "Success!" and fetch_status != "Failed!":
		$Layer2/UI/CheckUserData.text = fetch_status + dots
	elif fetch_status != "" and fetch_status == "Success!":
		$Layer2/UI/CheckUserData.text = fetch_status
	elif fetch_status != "" and fetch_status == "Failed!":
		$Layer2/UI/CheckUserData.text = fetch_status
	pass

func _check_accounts():
	if account_check < 4:
		if file.file_exists("user://account_"+str(account_check)+".dat"):
			file.open_encrypted_with_pass("user://account_"+str(account_check)+".dat", File.READ, GJKeys.encryption_key)
			userdata["username"+str(account_check)] = file.get_line()
			userdata["token"+str(account_check)] = file.get_line()
			slot_exist["slot"+str(account_check)] = true
			file.close()
			if selected_account == account_check:
				if soul.soulside == 2:
					soul_return()
					pass
		else:
			slot_exist["slot"+str(account_check)] = false
			if selected_account == account_check:
				if soul.soulside == 3:
					soul_return()
	pass

func _sync_accounts():
	if slot_exist["slot1"] and slot_exist["slot2"] and slot_exist["slot3"]:
		$Layer2/UI/SlotsFullPanel.show()
	else:
		$Layer2/UI/SlotsFullPanel.hide()
	if slot_exist["slot"+str(account_check)]:
		get_node("Layer2/UI/account_"+str(account_check)+"/Username").text = userdata["username"+str(account_check)]
	else:
		get_node("Layer2/UI/account_"+str(account_check)+"/Username").text = "?"
	pass

func _enable_input():
	$Layer2/UI/input_1.editable = false
	$Layer2/UI/input_2.editable = false
	$Layer2/UI/input_1.release_focus()
	$Layer2/UI/input_2.release_focus()
	if soul.soulside == 2:
		if soul.selected_choice_h < 3:
			get_node("Layer2/UI/input_"+str(soul.selected_choice_h)).grab_focus()
			get_node("Layer2/UI/input_"+str(soul.selected_choice_h)).editable = true
	pass

func soul_option():
	if soul.soulside == 1:
		_set_all_white(1)
		selected_account = soul.selected_choice_h
		if slot_exist["slot"+str(selected_account)] == false:
			soul.selected_choice_h = 1
			soul.soulside = 2
		else:
			soul.selected_choice_h = 1
			soul.soulside = 3
			soul.activate(2)
	elif soul.soulside == 2:
		if soul.selected_choice_h == 3:
			dots = ""
			soul._move_interact(false)
			_enable_input()
			_authenticate()
	elif soul.soulside == 3:
		if soul.selected_choice_w == 1:
			Borders.soul_interact = false
			PlayerData.username = str(userdata["username"+str(selected_account)])
			_authenticate()
		elif soul.selected_choice_w == 2:
			dir.remove("user://account_"+str(selected_account)+".dat")
	_move_soul()
	pass

func soul_return():
	if soul.soulside == 2:
		_set_all_white(2)
		$Layer2/UI/input_1.text = ""
		$Layer2/UI/input_2.text = ""
		soul.selected_choice_h = selected_account
		soul.soulside = 1
	elif soul.soulside == 3:
		_set_all_white(3)
		soul.activate(1)
		soul.selected_choice_h = selected_account
		soul.soulside = 1
	_move_soul()
	pass

func _authenticate():
	if soul.soulside == 2:
		GameJolt._login($Layer2/UI/input_1.text, $Layer2/UI/input_2.text, selected_account, true)
		auth_s = 2
	elif soul.soulside == 3:
		if soul.selected_choice_w == 1:
			anim_type = 0
			$Layer2/UI/MoveAllUp.get_animation("MoveUp").track_set_key_value(12, 1, Color8(255, 255, 255))
			$Layer2/UI/MoveAllUp.play("MoveUp")
	pass

func _change_auth():
	if auth_s == 1:
		$Layer2/UI/input_3.text = "Authenticate"
		$Layer2/UI/input_3.modulate = Color8(255, 255, 255)
	elif auth_s == 2:
		$Layer2/UI/input_3.text = "Authenticating" + dots
		$Layer2/UI/input_3.modulate = Color8(255, 255, 0)
	elif auth_s == 3:
		$Layer2/UI/input_3.text = "Authenticated"
		$Layer2/UI/input_3.modulate = Color8(0, 255, 0)
	elif auth_s == 4:
		$Layer2/UI/input_3.text = "Authentication Failed"
		$Layer2/UI/input_3.modulate = Color8(255, 0, 0)
	pass

func _move_soul():
	_set_color()
	if soul.soulside == 1:
		if has_node("Layer2/UI/account_"+str(soul.selected_choice_h)):
			var pos = get_node("Layer2/UI/account_"+str(soul.selected_choice_h)).rect_position + Vector2(-20,64)
			movesoul.interpolate_property(soul, "position",
			soul.position, pos, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			movesoul.start()
	elif soul.soulside == 2:
		if has_node("Layer2/UI/input_"+str(soul.selected_choice_h)):
			var pos = get_node("Layer2/UI/input_"+str(soul.selected_choice_h)).rect_position + Vector2(-20,10)
			movesoul.interpolate_property(soul, "position",
			soul.position, pos, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			movesoul.start()
	elif soul.soulside == 3:
		if has_node("Layer2/UI/option_"+str(soul.selected_choice_w)):
			var pos = get_node("Layer2/UI/option_"+str(soul.selected_choice_w)).rect_position + Vector2(-16.5,7.5)
			movesoul.interpolate_property(soul, "position",
			soul.position, pos, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			movesoul.start()
	pass

func _set_limits():
	if soul.soulside == 1 or soul.soulside == 2:
		soul.select_limit_h = 3
	elif soul.soulside == 3:
		soul.select_limit_w = 2
	pass

func _set_all_white(n):
	if n == 1:
		$Layer2/UI/account_1.modulate = Color8(255, 255, 255)
		$Layer2/UI/account_2.modulate = Color8(255, 255, 255)
		$Layer2/UI/account_3.modulate = Color8(255, 255, 255)
	elif n == 2:
		$Layer2/UI/input_1.modulate = Color8(255, 255, 255)
		$Layer2/UI/input_2.modulate = Color8(255, 255, 255)
		$Layer2/UI/input_3.modulate = Color8(255, 255, 255)
	elif n == 3:
		$Layer2/UI/option_1.modulate = Color8(255, 255, 255)
		$Layer2/UI/option_2.modulate = Color8(255, 255, 255)
	pass

func _set_color():
	_set_all_white(soul.soulside)
	if soul.soulside == 1:
		get_node("Layer2/UI/account_"+str(soul.selected_choice_h)).modulate = Color8(255, 255, 0)
	elif soul.soulside == 2:
		get_node("Layer2/UI/input_"+str(soul.selected_choice_h)).modulate = Color8(255, 255, 0)
	elif soul.soulside == 3:
		get_node("Layer2/UI/option_"+str(soul.selected_choice_w)).modulate = Color8(255, 255, 0)
	pass

func _on_account_check_timeout():
	if account_check < soul.select_limit_h:
		account_check += 1
	else:
		account_check = 1
	pass

func _on_dots_timeout():
	if dots != "...":
		dots += "."
	else:
		dots = ""
	if dots == "..":
		if auth_s == 3 or auth_s == 4:
			soul_return()
			Borders.soul_interact = true
			auth_s = 1
	pass # Replace with function body.


func _on_MoveAllUp_animation_finished(anim_name):
	if anim_name == "MoveUp":
		if anim_type == 0:
			$Layer2/UI/FriskLoading/Walk.play("Walk1")
			$Layer2/UI/FriskLoading.play("Walk")
			dots = ""
			GameJolt._login(userdata["username"+str(selected_account)], userdata["token"+str(selected_account)], selected_account, false)
		elif anim_type == 1:
			Borders.soul_interact = true
			pass
	elif anim_name == "MoveUp2":
		Borders.fade(69, "")
	pass # Replace with function body.
