extends NodeState

@onready var player = get_parent().get_parent() as Player
@onready var input = player.get_node("%InputSynchronizer")

# Get the sprite relative to the player
@onready var animated_sprite_2d = player.get_node("AnimatedSprite2D") as AnimatedSprite2D

func _ready() -> void:
	print("Watering state ready for player: ", player.player_id)
	# Optional: Check if sprite is valid in ready
	if not is_instance_valid(animated_sprite_2d):
		printerr("WateringState Error: AnimatedSprite2D node not found or invalid.")

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	# Check sprite validity before checking animation state
	if not is_instance_valid(animated_sprite_2d):
		printerr("WateringState Error: Cannot check transitions, AnimatedSprite2D invalid.")
		transition.emit("Idle") # Transition immediately if sprite is bad
		return
		
	if not animated_sprite_2d.is_playing():
		print("Watering animation finished for player: ", player.player_id)
		transition.emit("Idle")

func _on_enter() -> void:
	print("Enter watering for player: ", player.player_id)
	
	# Check sprite is valid before trying to play
	if not is_instance_valid(animated_sprite_2d):
		printerr("WateringState Error: Cannot play animation, AnimatedSprite2D invalid.")
		return
		
	var anim_name = player.get_animation_name("watering")
	print("Attempting to play animation: ", anim_name, " for player: ", player.player_id)
	if animated_sprite_2d.sprite_frames.has_animation(anim_name):
		animated_sprite_2d.play(anim_name)
		print("Animation playing: ", animated_sprite_2d.is_playing(), " for player: ", player.player_id)
	else:
		print("Error: Animation not found in watering state: ", anim_name)

func _on_exit() -> void:
	print("Exit watering for player: ", player.player_id)
	
	# SERVER ONLY: Consume the do_tool flag now that we've exited the action state.
	if multiplayer.is_server():
		if player.do_tool: # Check if it was true before resetting
			print("Server consuming do_tool flag in WateringState._on_exit")
			player.do_tool = false
		# else:
			# print("Server: do_tool was already false on WateringState exit")

	if is_instance_valid(animated_sprite_2d):
		animated_sprite_2d.stop()
