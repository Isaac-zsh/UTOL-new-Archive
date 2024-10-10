extends Node2D

var player_spawn = preload("res://GlobalScenes/PlayerServer.tscn")
var last_world_state = 0

func _ready():
	Server.SpawnRequest(0, "", "")
	$YSort/Player/Camera2D.limit_bottom = $Layer1/Image2.texture.get_height() + 60
	$YSort/Player/Camera2D.limit_right = $Layer1/Image2.texture.get_width() + 320
