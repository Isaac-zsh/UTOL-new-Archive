extends Node

var file = File.new()
var account_save = 0
var request_type = false
var name_save = ""
var token_save = ""
var what_to_fetch = ""
var debug = false

func _ready():
	_authinticate()
	pass

func _authinticate():
	$GameJoltAPI.init(GJKeys.PrivateKey, GJKeys.GameID)
	pass

func _login(username, token, account, save):
	request_type = save
	if debug != true:
		if request_type != true:
			get_node("/root/2").fetch_status = "Authenticating"
			account_save = account
	name_save = username
	token_save = token
	$GameJoltAPI.auth_user(username, token)
	pass

func fetch_data(a, b, c):
	$GameJoltAPI.fetch_data(a, b)
	what_to_fetch = c
	pass

func remove_data(a, b):
	$GameJoltAPI.remove_data(a, b)
	pass

func set_data(a, b, c):
	$GameJoltAPI.set_data(a, b, c)
	pass

func _logout():
	$GameJoltAPI.auth_user("", "")
	pass

func _on_GameJoltAPI_gamejolt_request_completed(type, message):
	if debug != true:
		if type == "/users/auth/":
			if request_type == true:
				if message.success:
					file.open_encrypted_with_pass("user://account_"+str(account_save)+".dat", File.WRITE, GJKeys.encryption_key)
					file.store_line(name_save)
					file.store_line(token_save)
					file.close()
					get_node("/root/2").auth_s = 3
					get_node("/root/2").dots = ""
					Audio.sfx(2, 0)
				else:
					get_node("/root/2").auth_s = 4
					get_node("/root/2").dots = ""
			else:
				if message.success:
					fetch_data("gold", false, "gold")
					get_node("/root/2").fetch_status = "Fetching Data" + "\n" + "Gold"
		elif type == "/data-store/":
			if message.success:
				if what_to_fetch == "gold":
					PlayerData.gold = message.data
					fetch_data("skin", false, "skin")
					get_node("/root/2").fetch_status = "Fetching Data" + "\n" + "Skin"
				elif what_to_fetch == "skin":
					PlayerData.skin = message.data
					fetch_data("hp", false, "hp")
					get_node("/root/2").fetch_status = "Fetching Data" + "\n" + "HP"
				elif what_to_fetch == "hp":
					PlayerData.hp = message.data
					get_node("/root/2").fetch_status = "Connecting to Server"
					Server._connect_server()
			else:
				if what_to_fetch == "gold":
					$GameJoltAPI.set_data("gold", 0, false)
					PlayerData.gold = 0
					fetch_data("skin", false, "skin")
				elif what_to_fetch == "skin":
					$GameJoltAPI.set_data("skin", 0, false)
					PlayerData.skin = 0
					fetch_data("hp", false, "hp")
				elif what_to_fetch == "hp":
					$GameJoltAPI.set_data("hp", 20, false)
					PlayerData.hp = 20
					get_node("/root/2").fetch_status = "Connecting to Server"
					Server._connect_server()
	else:
		print(type, message)
	#elif type == "/users/auth/":
	pass
