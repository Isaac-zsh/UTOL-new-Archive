extends Node2D

var soul_sel_a = 0
var soul_sel = 1
var soul_speed = 0.35
var opb_prefix = "bo_1"
var opb_change_pos = Vector2(-38, 0)
var enemies = ["Dummy", "Dummy", "Dummy"]
var enemynum = 0

onready var pos_change = $pos_change
onready var soul = $Soul
onready var opb_count = get_tree().get_nodes_in_group("bottom_options").size()

func _ready():
	for entity in range(enemies.size()):
		var enemy = preload("res://TestScenes/Enemy.tscn").instance()
		enemy.name = str(enemies[entity-1])+"-"+str(entity)
		enemy.hp = 20
		add_child(enemy)
	pass

func _input(event):
	if int(opb_prefix.split("_")[1]) == 1:
		if Input.is_action_just_pressed("ui_right"):
			if soul_sel < opb_count:
				soul_sel += 1
			else:
				soul_sel = 1
			_color_buttons()
		if Input.is_action_just_pressed("ui_left"):
			if soul_sel > 1:
				soul_sel -= 1
			else:
				soul_sel = opb_count
			_color_buttons()
	pass

func _color_buttons():
	for button in get_tree().get_nodes_in_group("bottom_options"):
		if button.name != "bo"+str(soul_sel):
			button.play("normal")
		else:
			button.play("selected")
	pos_change.interpolate_property(soul, "position", soul.position, get_node(opb_prefix.split("_")[0]+str(soul_sel)).position+opb_change_pos, soul_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	pos_change.start()
	pass
