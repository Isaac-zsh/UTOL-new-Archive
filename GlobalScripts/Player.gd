extends KinematicBody2D

var speed = 200
var player_state
var animation_to_play = ""
var velocity = Vector2.ZERO
var last_world_state = 0

func _ready():
	set_physics_process(true)
	Borders.fade(-2, "")
	pass

func _process(delta):
	_set_player_name(0)
	if speed > 200:
		speed = 200
	$CollisionShape2D.shape.extents = $Player.get_sprite_frames().get_frame(str($Player.selected_player)+"_DownIdle",0).get_size() /2
	pass

func _set_player_name(mode):
	if mode == 0:
		$Username.text = str(PlayerData.username)
	pass

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed('Right'):
		animation_to_play = str($Player.selected_player)+"_Right"
		velocity.x += 2
	if Input.is_action_pressed('Left'):
		animation_to_play = str($Player.selected_player)+"_Left"
		velocity.x -= 2
	if Input.is_action_pressed('Down'):
		animation_to_play = str($Player.selected_player)+"_Down"
		velocity.y += 2
	if Input.is_action_pressed('Up'):
		animation_to_play = str($Player.selected_player)+"_Up"
		velocity.y -= 2
	if Input.is_action_pressed('Up'):
		if Input.is_action_pressed('Right') or Input.is_action_pressed('Left'):
			speed = 300
		else:
			speed = 270
	elif Input.is_action_pressed('Down'):
		if Input.is_action_pressed('Right') or Input.is_action_pressed('Left'):
			speed = 300
		else:
			speed = 270
	if animation_to_play != "":
		$Player.play(animation_to_play+"Walk")
	velocity = velocity.normalized() * speed

func DefinePlayerState():
	player_state = {"T": OS.get_system_time_msecs(), "P": get_global_position(), "U": $Username.text, "AN": $Player.get_animation(), "AF": $Player.get_frame(), "R": get_tree().get_current_scene().get_name()}
	Server.SendPlayerState(player_state)
	pass

func UpdateWorldState(world_state):
	if world_state["T"] > last_world_state:
		last_world_state = world_state["T"]
		world_state.erase("T")
		world_state.erase(get_tree().get_network_unique_id())
		for player in world_state.keys():
			if world_state[player]["R"] == get_tree().get_current_scene().get_name():
				if get_node("../OtherPlayers").has_node(str(player)):
					get_node("../OtherPlayers/" + str(player)).MovePlayer(world_state[player]["P"])
					get_node("../OtherPlayers/" + str(player)).SetAnim(str(world_state[player]["AN"]), world_state[player]["AF"])
					get_node("../OtherPlayers/" + str(player)).SetName(str(world_state[player]["U"]))
				else:
					Server.SpawnRequest(1, player, world_state[player]["P"])
			else:
				if get_node("../OtherPlayers").has_node(str(player)):
					Server.DespawnPlayer(player)
	pass

func _physics_process(delta):
	DefinePlayerState()
	get_input()
	velocity = move_and_slide(velocity)
	if velocity == Vector2.ZERO:
		if animation_to_play != "":
			$Player.play(animation_to_play+"Idle")
