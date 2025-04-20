extends Node

# Signal emitted by ToolsPanel via GameManager when the local player selects a tool
signal local_tool_selected(tool_type: DataTypes.Tools)

func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server...")
		MultiplayerManager.become_host()
	# Connect the signal to our handler function
	local_tool_selected.connect(_on_local_tool_selected)

func become_host():
	print("Game Manager: Host game button pressed")
	MultiplayerManager.become_host()
	# Add your host game logic here

func join_as_player():
	print("Multiplayer Manager: Join as player 2 button pressed")
	MultiplayerManager.join_as_player()
	# Add your join game logic here

# Handles the global signal emitted when a tool button is pressed
func _on_local_tool_selected(tool_type: DataTypes.Tools) -> void:
	# Find the local player dynamically
	var local_id = multiplayer.get_unique_id()
	# Check if the local ID is valid for sending RPC
	if local_id == 0 or (local_id == 1 and not multiplayer.is_server()): 
		return
		
	# --- Find the correct Player node --- 
	# TODO: Consider making players_node_path configurable or dynamically found
	var players_node_path = "/root/TestSceneMultiplayer/Players" 
	var players_node = get_node_or_null(players_node_path)
	if not is_instance_valid(players_node):
		return
		
	var local_player_node_path = str(local_id)
	var local_player = players_node.get_node_or_null(local_player_node_path)

	if not is_instance_valid(local_player):
		return
		
	# Check if it's actually a Player node 
	if not local_player is Player:
		return

	# --- Send RPC --- 
	# Final check before RPC (optional but safe)
	if not is_instance_valid(local_player):
		return

	# Send the RPC to the server (peer 1) to update the tool
	local_player.update_tool_server.rpc_id(1, tool_type) 
