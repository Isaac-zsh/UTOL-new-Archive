extends Node2D

onready var Soul = $Layer4/SoulPlayer
onready var movesoul = get_node("MoveSoul")

func _ready():
	Audio.music(0, 0)
	Soul.sprite(1)
	Borders.fade(-2, "")
	Soul.select_limit_h = 3
	pass

func _process(_delta):
	if has_node("Layer4/Labels/t_"+str(Soul.selected_choice_h)):
		if Soul.mode == 0:
			Soul.position = get_node("Layer4/Labels/t_"+str(Soul.selected_choice_h)).rect_position + Vector2(-16,10)
		get_node("Layer4/Labels/t_1").modulate = Color8(255,255,255)
		get_node("Layer4/Labels/t_2").modulate = Color8(255,255,255)
		get_node("Layer4/Labels/t_3").modulate = Color8(255,255,255)
		get_node("Layer4/Labels/t_"+str(Soul.selected_choice_h)).modulate = Color8(255,255,0)
	pass

func _move_soul():
	if has_node("Layer4/Labels/t_"+str(Soul.selected_choice_h)):
		var pos = get_node("Layer4/Labels/t_"+str(Soul.selected_choice_h)).rect_position + Vector2(-16,10)
		movesoul.interpolate_property($Layer4/SoulPlayer, "position",
		$Layer4/SoulPlayer.position, pos, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		movesoul.start()
	pass

func _input(_event):
	if Input.is_action_just_pressed("Accept"):
		#Borders.fade(1)
		pass

func soul_option():
	Borders.fade(Soul.selected_choice_h+1, "")
	pass

func _on_Menu_animation_finished(_anim_name):
	Soul.activate(1)
	pass # Replace with function body.
