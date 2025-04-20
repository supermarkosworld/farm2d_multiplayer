extends MultiplayerSynchronizer

@onready var player = $".."

var input_direction: Vector2 = Vector2.ZERO

func _ready():
	# IMPORTANT: Synchronization for 'input_direction' and 'do_tool' 
	# must be configured in the Godot Editor Inspector for this MultiplayerSynchronizer node.
	# Ensure both are set to Reliable replication mode.

	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process_unhandled_input(false) # Disable _unhandled_input for non-authority
		set_physics_process(false)
		# Disable _process if not needed for other things
		set_process(false) 

func _physics_process(_delta):
	# Only process physics for the authority
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return 
		
	# Handle 2D movement input using Vector2 constants
	var direction = Vector2.ZERO # Local calculation, then synchronized via editor config
	if Input.is_action_pressed("walk_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("walk_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("walk_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("walk_down"):
		direction = Vector2.DOWN
	
	input_direction = direction

func is_moving() -> bool:
	# This function might be called on non-authoritative peers, 
	# relying on the synchronized input_direction value.
	return input_direction != Vector2.ZERO


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Use _unhandled_input to catch events *after* GUI has processed them
func _unhandled_input(event: InputEvent) -> void:
	# Only handle input for the local player
	if not is_multiplayer_authority():
		return

	# Check if this specific unhandled event is the "do_tool" action (Left Click by default)
	# This ensures we only react if the GUI did *not* consume the event in ToolsPanel.gd
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and event.is_action_pressed("do_tool"):
		print("Input: 'do_tool' action (Left Click) detected in _unhandled_input. Sending RPC...")
		# Send RPC to server to request the tool action
		server_request_tool_action.rpc_id(1)



# Renamed RPC for clarity - called by client, executed on server (id 1)
@rpc("any_peer", "call_local", "reliable")
func server_request_tool_action():
	# Ensure this only runs on the server
	if not multiplayer.is_server():
		return

	print("Server received tool action request, setting player.do_tool = true")
	# Server sets the value, which will be automatically synchronized 
	# to all clients via the MultiplayerSynchronizer (if configured in editor).
	if not player.do_tool:
		player.do_tool = true
