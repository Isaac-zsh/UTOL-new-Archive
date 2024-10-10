extends Node2D

var boss = preload("res://scenes/BattleEngine.tscn").instance()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		 add_child(boss)
		 boss.get_node("Soul").position = $Icon.position
	pass
