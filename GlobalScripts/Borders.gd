extends Node2D

var default = false
var room_num = 0
var soul_interact = true

func _process(_delta):
	$Debug.visible = DebugMode.debug
	pass

func fade(num, text):
	if num == -2:
		$CanvasLayer/Panel/Fade.play("FadeIn")
	elif num  == -1:
		$CanvasLayer/Text.visible = true
		$CanvasLayer/Text.text = text
		$CanvasLayer/Panel/Fade.play("FadePopUp")
	else:
		soul_interact = false
		room_num = num
		$CanvasLayer/Panel/Fade.get_animation("FadeOut").track_set_key_value(0,0, $CanvasLayer/Panel.modulate)
		$CanvasLayer/Panel/Fade.play("FadeOut")

func _on_Fade_animation_finished(anim_name):
	if anim_name == "FadeOut":
		if room_num != 69:
			soul_interact = true
			Scene.switch(room_num)
		else:
			get_tree().change_scene("res://TestScenes/scene1.tscn")
	elif anim_name == "FadePopUp":
		$CanvasLayer/Text.visible = false
	pass # Replace with function body.
