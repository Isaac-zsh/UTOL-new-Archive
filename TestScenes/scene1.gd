extends Node2D

var player_spawn = preload("res://GlobalScenes/PlayerServer.tscn")
var boss = preload("res://Scenes&Scripts/BattleEngine.tscn").instance()

func _ready():
	Server.SpawnRequest(0, "", "")
	$YSort/Player/Camera2D.limit_bottom = $Layer1/Image1.texture.get_height() + 60
	$YSort/Player/Camera2D.limit_right = $Layer1/Image1.texture.get_width() + 320

func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://TestScenes/scene2.tscn")
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("Return"):
		 add_child(boss)
		 boss.get_node("Soul").position = $YSort/Player.position
	pass
