extends Node2D

func _ready():
	Borders.fade(-2, "")
	pass

func _on_add_pressed():
	GameJolt.set_data($input.text, $input2.text, $CheckButton.pressed)
	pass # Replace with function body.

func _on_delete_pressed():
	GameJolt.remove_data($input.text, $CheckButton.pressed)
	pass # Replace with function body.

func _on_fetch_pressed():
	GameJolt.fetch_data($input.text, $CheckButton.pressed, 99)
	pass

func _on_auth_pressed():
	GameJolt.debug = true
	GameJolt._login($name.text, $token.text, 99, false)
	pass # Replace with function body.
