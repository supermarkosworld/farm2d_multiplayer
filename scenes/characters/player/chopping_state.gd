extends NodeState

@onready var player = get_parent().get_parent() as Player
@onready var input = player.get_node("%InputSynchronizer")

# Use @onready to get the node relative to the player
@onready var animated_sprite_2d = player.get_node("AnimatedSprite2D") as AnimatedSprite2D
# Keep reference to HitComponent if needed, but state will manage shape directly
@onready var hit_component: HitComponent = player.get_node("HitComponent") as HitComponent 
# Correct path: Get shape node as child of HitComponent
@onready var hit_component_collision_shape: CollisionShape2D = player.get_node_or_null("HitComponent/HitComponentShape2D") as CollisionShape2D

# ADD: Need state variable for animation/exit logic
var can_exit: bool = false 

func _ready() -> void:
	print("Chopping state ready for player: ", player.player_id)
	hit_component_collision_shape.disabled = true


func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:

	if not animated_sprite_2d.is_playing(): # Assuming exit happens right after animation finishes
		print("Animation finished for player: ", player.player_id)
		transition.emit("Idle")

func _on_enter() -> void:
	print("Enter chopping for player: ", player.player_id)
	can_exit = false # Ensure can_exit flag is reset

		
	var anim_name = player.get_animation_name("chopping")
	animated_sprite_2d.play(anim_name)

	if is_instance_valid(hit_component_collision_shape):
		var x_pos = player.player_direction.x * 9 
		var y_pos = 0
		if player.player_direction.y > 0: # Facing down/front
			y_pos = 3 
		elif player.player_direction.y < 0: # Facing up/back
			y_pos = -17 
		hit_component_collision_shape.position = Vector2(x_pos, y_pos)
		hit_component_collision_shape.disabled = false
		print("ChoppingState: Enabled and positioned HitComponentShape2D")
	else:
		printerr("ChoppingState Error: Cannot position/enable shape, HitComponent/HitComponentShape2D not found!")

func _on_exit() -> void:
	print("Exit chopping for player: ", player.player_id)

	# SERVER ONLY: Consume the do_tool flag now that we've exited the action state.
	if multiplayer.is_server():
		if player.do_tool: # Check if it was true before resetting
			print("Server consuming do_tool flag in ChoppingState._on_exit")
			player.do_tool = false


	animated_sprite_2d.stop()
	hit_component_collision_shape.disabled = true
