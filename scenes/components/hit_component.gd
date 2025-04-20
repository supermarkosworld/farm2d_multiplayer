class_name HitComponent
extends Area2D

@export var current_tool : DataTypes.Tools = DataTypes.Tools.None
@export var hit_damage : int = 1

func _ready() -> void:
	# Override default Area2D collision settings (which are layer 8, mask 16)
	# Set our specific collision settings:
	# Layer 4: Tools (this component)
	# Layer 5: Objects (what we want to detect)
	collision_layer = 4
	collision_mask = 5
	
	# Ensure area detection is enabled
	monitoring = true
	monitorable = true
	
	print("HitComponent ready")
	print("Overriding default Area2D collision settings (8,16) with:")
	print("Collision layer: ", collision_layer, " (Tools)")
	print("Collision mask: ", collision_mask, " (Objects)")
	print("Monitoring: ", monitoring)
	print("Monitorable: ", monitorable)
