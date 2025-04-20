extends Node

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

var multiplayer_scene = preload("res://scenes/characters/player/Player.tscn")
var _players_spawn_node
const SPAWN_POSITION = Vector2(300, 300)
const PLAYER_SPAWN_OFFSET = Vector2(-10, 0)
var host_mode_enabled: bool = false

func _ready():
	_players_spawn_node = get_tree().get_current_scene().get_node("Players")

func become_host():
	print("Starting host!")
	
	var server_peer = ENetMultiplayerPeer.new()
	var err = server_peer.create_server(SERVER_PORT)
	if err != OK:
		push_error("Failed to create server: %s" % err)
		return
		
	multiplayer.multiplayer_peer = server_peer
	host_mode_enabled = true
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	print("Server started with ID: ", multiplayer.get_unique_id())
	
	# Don't spawn player if we're a dedicated server
	if not OS.has_feature("dedicated_server"):
		# Spawn host player
		_add_player_to_game(1)  # Host is always player 1

func join_as_player():
	print("Joining existing game")
	host_mode_enabled = false
	
	var client_peer = ENetMultiplayerPeer.new()
	var err = client_peer.create_client(SERVER_IP, SERVER_PORT)
	if err != OK:
		push_error("Failed to join game: %s" % err)
		return
		
	multiplayer.multiplayer_peer = client_peer
	
	# Connect signals for client as well
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	# When client connects, spawn both host and client players
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	
	print("Client connected with ID: ", multiplayer.get_unique_id())

func _on_connected_to_server():
	print("Connected to server!")
	# Only spawn our player
	_add_player_to_game(multiplayer.get_unique_id())

func _add_player_to_game(id: int):
	# 'id' here is the unique network peer ID
	print("Adding player with Network Peer ID: %s" % id) 
	
	# Don't add if player already exists (check by network ID name)
	if _players_spawn_node.has_node(str(id)):
		print("Player node named %s already exists" % id)
		return

	# Determine spawn index based on current player count
	var spawn_index = _players_spawn_node.get_child_count()
	print("Current player count (for spawn index): %d" % spawn_index)

	var player_to_add = multiplayer_scene.instantiate()
	# Assign the unique network peer ID for authority/identification
	player_to_add.player_id = id 
	# Name the node using the unique network peer ID
	player_to_add.name = str(id)
	
	# Calculate offset position using the spawn_index (0, 1, 2, ...)
	var calculated_spawn_pos = SPAWN_POSITION + (PLAYER_SPAWN_OFFSET * spawn_index)
	player_to_add.position = calculated_spawn_pos 
	print("Attempting to spawn player %s (Index %d) at calculated position: %s" % [id, spawn_index, calculated_spawn_pos])
	
	_players_spawn_node.add_child(player_to_add, true)
	print("Player added to scene with Network ID: %s" % id)
	# Verify position immediately after adding (for debugging)
	if is_instance_valid(player_to_add):
		print("Player %s actual position after add_child: %s" % [id, player_to_add.position])

func _del_player(id: int):
	print("Player %s left the game!" % id)
	
	# Original cleanup
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).queue_free()
	
	
	
	
	
	
	
	
	
	
	
