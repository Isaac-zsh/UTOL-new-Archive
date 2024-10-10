extends Control

var game_version_id = 0

func _ready():
	set_physics_process(false)
	$SoulPlayer.sprite(2)
	Borders.fade(-2, "")
	$SoulPlayer.scale.x = 2
	$SoulPlayer.scale.y = 2
	$GameJoltAPI.init(GJKeys.PrivateKey, GJKeys.GameID)
	_fetch_game_version()
	pass

func _fetch_game_version():
	$CurrentCheck.text = "Checking Game Version..."
	$GameJoltAPI.fetch_data("game_version_id", true)
	pass

func _on_GameJoltAPI_gamejolt_request_completed(type, message):
	if type == "/data-store/":
		if int(message.data) == game_version_id:
			$SoulPlayer.sprite(1)
			Audio.sfx(2, 0)
			Borders.fade(1, "")
	pass

func _success():
	$CurrentCheck.modulate = Color8(255,255,0)
	$CurrentCheck.text = "Success"
	pass
