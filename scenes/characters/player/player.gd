class_name Player
extends CharacterBody2D

var player_direction: Vector2
var current_speed: float = 50.0  # Default speed if no state sets it
var do_tool = false

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None
@export var hit_component: HitComponent

@export var player_id: int = 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

func get_player_id() -> int:
	return player_id

func _ready() -> void:
	print("Player ready for id: ", player_id, ", Authority: ", is_multiplayer_authority())
	print("Player collision layer: ", collision_layer)
	print("Player collision mask: ", collision_mask)

func _exit_tree() -> void:
	print("Player ", player_id, ": _exit_tree called. Authority: ", is_multiplayer_authority())


func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		_apply_movement_from_input(delta)

func _apply_movement_from_input(delta: float) -> void:
	var input = %InputSynchronizer
	
	# Apply movement using current_speed (set by states)
	if input.input_direction != Vector2.ZERO:
		velocity = input.input_direction * current_speed
		player_direction = input.input_direction
	else:
		velocity = velocity.move_toward(Vector2.ZERO, current_speed)
	
	move_and_slide()

# Dictionary to map directions to animation names
var direction_enum: Dictionary = {
	Vector2(1, 0): "right",
	Vector2(-1, 0): "left",
	Vector2(0, 1): "front",
	Vector2(0, -1): "back",
}

# Function to get the animation name
func get_animation_name(state: String) -> String:
	if direction_enum.has(player_direction):
		return state + "_" + direction_enum[player_direction]
	return state + "_front"


# RPC function called by the client, executed on the server (peer 1).
@rpc("any_peer", "call_local", "reliable")
func update_tool_server(new_tool: DataTypes.Tools):
	# Ensure this only runs on the server
	if not multiplayer.is_server():
		return
		
	print("Server received tool update for player ", player_id, ": ", new_tool)
	current_tool = new_tool
	if is_instance_valid(hit_component):
		hit_component.current_tool = current_tool
