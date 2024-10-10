extends Node

var network = NetworkedMultiplayerENet.new()
var player_spawn = preload("res://GlobalScenes/PlayerServer.tscn")

func _end_auth():
	get_node("/root/2").end_auth()
	pass

func _auth_fail():
	get_node("/root/2")._auth_failed()
	pass

func SendPlayerState(player_state):
	rpc_unreliable_id(1, "ReceivePlayerState", player_state)
	pass

remote func ReceiveWorldState(world_state):
	if get_tree().get_current_scene().get_name() != "2":
		get_node("/root/"+get_tree().get_current_scene().get_name()+"/YSort/Player").UpdateWorldState(world_state)
	pass

func SpawnRequest(num, arg1, arg2):
	if num == 0:
		rpc_unreliable_id(1, "SpawnPlayer")
	else:
		SpawnPlayer(arg1, arg2)
	pass

func _spawn_state_players(player_id, spawn_position):
	get_node("/root/"+get_tree().get_current_scene().get_name()).SpawnNewPlayer(player_id, spawn_position)
	pass

remote func SpawnPlayer(player_id, spawn_position):
	if get_tree().get_current_scene().get_name() != "2":
		if get_tree().get_network_unique_id() == player_id:
			pass
		else:
			if not get_node("/root/"+get_tree().get_current_scene().get_name()+"/YSort/OtherPlayers").has_node(str(player_id)):
				var new_player = player_spawn.instance()
				new_player.position = spawn_position
				new_player.name = str(player_id)
				get_node("/root/"+get_tree().get_current_scene().get_name()+"/YSort/OtherPlayers").add_child(new_player)
	pass

remote func DespawnPlayer(player_id):
	get_node("/root/"+get_tree().get_current_scene().get_name()+"/YSort/OtherPlayers/"+str(player_id)).queue_free()
	pass

func _connect_server():
	network.create_client("127.0.0.1", 1425)
	get_tree().network_peer = network
	network.connect("connection_failed", self, "_OnConnectionFailed")
	network.connect("connection_succeeded", self, "_OnConnectionSucceeded")
	pass

func _OnConnectionFailed():
	print("Failed to connect")
	network.close_connection()
	_auth_fail()
	pass

func _OnConnectionSucceeded():
	print("Connected to server!")
	_end_auth()
	pass
