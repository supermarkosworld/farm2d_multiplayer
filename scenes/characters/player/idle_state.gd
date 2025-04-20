# IdleState.gd
extends NodeState

# Use @onready to get the node relative to the player
@onready var player = get_parent().get_parent() as Player
@onready var input = player.get_node("%InputSynchronizer")
@onready var animated_sprite_2d = player.get_node("AnimatedSprite2D") as AnimatedSprite2D

func _on_enter() -> void:
	# Optional: Check if sprite is valid on enter
	if not is_instance_valid(animated_sprite_2d):
		printerr("IdleState Error: AnimatedSprite2D node not found or invalid.")

func _on_process(_delta: float) -> void:
	pass

func _on_physics_process(_delta: float) -> void:
	# Play idle animation if there's no movement input
	if is_instance_valid(animated_sprite_2d) and not input.is_moving():
		var anim_name = player.get_animation_name("idle")
		if animated_sprite_2d.sprite_frames.has_animation(anim_name):
			# Prevent spamming play if already playing the same animation
			if not animated_sprite_2d.is_playing() or animated_sprite_2d.animation != anim_name:
				animated_sprite_2d.play(anim_name)
		# else: print warning if anim not found?

func _on_exit() -> void:
	print("Idle state exiting")
	if is_instance_valid(animated_sprite_2d):
		animated_sprite_2d.stop()

func _on_next_transitions() -> void:
	# Handle movement transitions FIRST (higher priority)
	if input.is_moving():
		transition.emit("Walk")
		return # Don't check for tool if moving

	# Handle tool transitions only if not moving
	if player.do_tool:
		print("Idle state detected do_tool")
		var target_state = ""
		match player.current_tool:
			DataTypes.Tools.AxeWood:
				print("Transitioning to Chopping")
				target_state = "Chopping"
			DataTypes.Tools.TillGround:
				print("Transitioning to Tilling")
				target_state = "Tilling"
			DataTypes.Tools.WaterCrops:
				print("Transitioning to Watering")
				target_state = "Watering"
		
		if target_state != "":
			transition.emit(target_state)
		# else:
			# Handle case where tool is set but not recognized?
			# REMOVED: Server reset is moved to the action state's _on_enter
			# if multiplayer.is_server():
			# 	player.do_tool = false
