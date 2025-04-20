extends NodeState

@export var walk_speed: float = 50.0

# Use @onready to get nodes relative to the player
@onready var player = get_parent().get_parent() as Player
@onready var input = player.get_node("%InputSynchronizer")
@onready var animated_sprite_2d = player.get_node("AnimatedSprite2D") as AnimatedSprite2D

func _on_enter() -> void:
	player.current_speed = walk_speed
	# Optional: Check if sprite is valid on enter
	if not is_instance_valid(animated_sprite_2d):
		printerr("WalkState Error: AnimatedSprite2D node not found or invalid.")

func _on_physics_process(delta: float) -> void:
	# Play walk animation if moving
	if is_instance_valid(animated_sprite_2d) and input.is_moving():
		var anim_name = player.get_animation_name("walk")
		if animated_sprite_2d.sprite_frames.has_animation(anim_name):
			# Prevent spamming play if already playing the same animation
			if not animated_sprite_2d.is_playing() or animated_sprite_2d.animation != anim_name:
				animated_sprite_2d.play(anim_name)
		# else: print warning if anim not found?
	# Consider stopping animation if not moving, although Idle state should take over
	# else:
	# 	if is_instance_valid(animated_sprite_2d):
	# 		animated_sprite_2d.stop()

func _on_next_transitions() -> void:
	if !input.is_moving():
		transition.emit("Idle")

func _on_exit() -> void:
	# Stop animation when exiting walk state
	if is_instance_valid(animated_sprite_2d):
		animated_sprite_2d.stop()
